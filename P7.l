%{
#include "P.tab.h"
#include "P7.h"
%}

/* Regular expression definitions */
digit                   [0-9]
alpha                   [a-zA-Z]
alphaNum                [a-zA-Z0-9]
special                 [\!\+*\/=\-\.,?`~@\$%\^&\;\:'"<>\_\(\)]
space                   [ ]
text                    ({alphaNum}|{special})*
newtext                 {text}({space}{text})*
url                     (http)(?:s)?(:\/\/){newtext}
newline                 \\n
table_col               \{|c|[c|]*\}
%%

\\section                { return TOKSECTION; }
\\subsection             { return TOKSUBSECTION; }
\\subsubsection          { return TOKSUBSUBSECTION; }
\\textbf                 { yylval.str = strdup(yytext); return TOKBOLD; }
\\textit                 { yylval.str = strdup(yytext); return TOKITALIC; }
\\texttt                 { return TOKMONOSPACE; }
\\hrule                  { return TOKHRULE; }
\\par                    { return TOKPARAGRAPH; }
\\begin\{verbatim\}      { return TOKSTRT_CODE_BLOCK; }
\\end\{verbatim\}        { return TOKEND_CODE_BLOCK; }
\\href                   { return TOKLINK; }
{url}                    { yylval.str = strdup(yytext); return TOKURL; }
\\includegraphics        { return TOKIMAGE; }
\\begin\{itemize\}       { return TOKSTRT_ITEMIZE; }
\\end\{itemize\}         { return TOKEND_ITEMIZE; }
\\begin\{enumerate\}     { return TOKSTRT_ENUMERATE; }
\\end\{enumerate\}       { return TOKEND_ENUMERATE; }
\{                       { return TOKCURLYOPEN; }
\}                       { return TOKCURLYCLOSE; }
{newline}                { return TOKNEWLINE; }
\\begin\{document\}      { return TOKBEGINDOC; }
\\end\{document\}        { return TOKENDDOC; }
"    \\item "            { return TOKITEM; }
{newtext}                { yylval.str = strdup(yytext); return TOKPLAIN_TEXT; }
[ \n\t\r]                ;
%%