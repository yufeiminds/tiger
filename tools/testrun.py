#coding=utf8

import os.path
import subprocess
import click
from pprint import pprint

TIGER_PATH = '../tiger/tiger'
TESTS_FOLDER = '../tests'


def check(fpath, exit_code):
    process = subprocess.Popen([TIGER_PATH], 
                               stdin=subprocess.PIPE,
                               stdout=subprocess.PIPE)
    with open(fpath) as f:
        process.communicate(f.read())
    return process.returncode == exit_code


def check_folder(folder, exit_code):
    checked = []
    for dirname, _, fnames in os.walk(folder):
        for name in fnames:
            if not name.endswith('.tig'):
                continue
            fpath = os.path.join(dirname, name)
            r = check(fpath, exit_code)
            checked.append((dirname, name, r))
    return checked
            

@click.group()
def cli():
    """
    Command line.
    """
    pass


@cli.command()
def run():
    """
    Run all tests.
    """
    good = []
    bad = []
    good.extend(check_folder(os.path.join(TESTS_FOLDER, "Official", "Good"), 0))
    bad.extend(check_folder(os.path.join(TESTS_FOLDER, "Official", "Bad"), 1))
    good.extend(check_folder(os.path.join(TESTS_FOLDER, "More", "Good"), 0))
    bad.extend(check_folder(os.path.join(TESTS_FOLDER, "More", "Bad"), 1))
    import jinja2
    env = jinja2.Environment(loader=jinja2.FileSystemLoader('templates'))
    template = env.get_template('testing.html')
    html = template.render(good=good, bad=bad)
    with open('build/testing.html', 'w') as f:
        f.write(html.encode('utf8'))


if __name__ == '__main__':
    cli()
