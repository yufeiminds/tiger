
%{
    /* 这段代码会被插入到生成代码中 */
%}

%option noyywrap        // 配置选项

whitespace  [ \t\n\r]   // 预定义正则

%x COMMENT              // 定义有限自动机的状态

%%

/* 正则有限状态机 */
"+"             { }     // 完全匹配
{whitespace}    { }     // 使用预定义正则
[0-9]+          { }     // 手写正则

/* 手写有限状态机 */
"/*"            { BEGIN COMMENT;    }               // 开始一个有限状态机
<COMMENT>"*/"   { BEGIN INITIAL;    }               // 切换到另一个有限状态机(起始态)
<COMMENT>.      { /* eat the block comments */  }   // 吞掉注释

%%

/*
 * 这里的代码会被插入到生成代码的最后面
 */