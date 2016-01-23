# coding=utf8

"""
Copyright 2016 Yufei Li

Report commits of github to html/pdf
"""

import os
import jinja2
import requests
import click
import datetime
import markdown
import pdfkit
import envelopes


class TigerReport(object):

    ALL = 0
    WEEKLY = 1

    def __init__(self, user, repo, mode, branch='master'):
        self.user = user
        self.repo = repo
        self.mode = mode
        self.branch = branch

        self._data = None
        self._env = jinja2.Environment(loader=jinja2.FileSystemLoader('templates'))
        self._env.filters['markdown'] = markdown.markdown
        self._env.globals['now'] = datetime.datetime.now

    @property
    def meta(self):
        return {
            "user": self.user,
            "repo": self.repo,
            "branch": self.branch
        }

    @property
    def data(self):
        if self._data:
            return self._data

        if self.mode == TigerReport.WEEKLY:
            now = datetime.datetime.now()
            self._params = {
                "since": now - datetime.timedelta(days=7),
                "until": now
            }
        else:
            self._params = {}

        r = requests.get('https://api.github.com/repos/{user}/{repo}/commits'
                         .format(**self.meta), params=self._params)
        self._data = r.json()

        return self._data

    def template(self, filename):
        return self._env.get_template(filename)

    @property
    def html(self):
        return self.template('weekly.html').render(commits=self.data, **self.meta)


@click.command()
@click.option('-f', '--format', default='html', help=u'报告生成格式')
@click.option('-o', '--output', default='build', help=u"报告生成目录")
@click.option('-e', '--email', default=[], multiple=True, help=u"报告发送对象")
def build(format, output, email):
    t = TigerReport('yufeiminds', 'tiger', TigerReport.WEEKLY)
    html = t.html
    if not os.path.exists(output):
        os.mkdir(output)
    fp = os.path.join(output, datetime.datetime.now().strftime('%F'))

    if format == 'html':
        with open(fp + '.html', 'w') as fd:
            fd.write(html.encode('utf8'))
    if format == 'pdf':
        pdfkit.from_string(html, fp + '.pdf')

    if email:
        envelope = envelopes.Envelope(
            from_addr=(u'yufeiminds@163.com', u'Yufei Li'),
            to_addr=email,
            subject=u'毕业设计进度周报',
            html_body=html,
            text_body=None,
            cc_addr=None,
            bcc_addr=None,
            headers=None,
            charset='utf-8',
        )
        if format == 'pdf':
            envelope.add_attachment(fp + '.pdf')
        envelope.send('smtp.163.com',
                      login=os.environ['EMAIL_163_USERNAME'],
                      password=os.environ['EMAIL_163_PASSWORD'],
                      tls=True)


if __name__ == '__main__':
    build()
