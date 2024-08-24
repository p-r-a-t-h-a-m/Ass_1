%{
#include "P.tab.h"
#include "P7.h"
%}

/* Regular expression definitions */
digit                   [0-9]
alpha                   [a-zA-Z]
alphaNum                [a-zA-Z0-9]
special                 [\!\+\/=\-\.,?`~@\$%\^&\;\:'"<>\_\(\)]
space                   [ ]
text                    ({alphaNum}|{special})*
newtext                 {text}({space}{text})*
url                     (http)(?:s)?(:\/\/){newtext}
newline                 \\n
table_col               \{|c|[c|]*\}
%%

\\section                { return SECTION; }
\\subsection             { return SUBSECTION; }
\\subsubsection          { return SUBSUBSECTION; }
\\textbf                 { yylval.str = strdup(yytext); return BOLD; }
\\textit                 { yylval.str = strdup(yytext); return ITALIC; }
\\hrule                  { return HLINE; }
\\par                    { return PAR; }
\\begin\{verbatim\}      { return CODE_BEGIN; }
\\end\{verbatim\}        { return CODE_END; }
\\href                   { return HREF; }
{url}                    { yylval.str = strdup(yytext); return URL; }
\\includegraphics        { return IMAGE; }
\\begin\{itemize\}       { return ITEMIZE_BEGIN; }
\\end\{itemize\}         { return ITEMIZE_END; }
\\begin\{enumerate\}     { return ENUMERATE_BEGIN; }
\\end\{enumerate\}       { return ENUMERATE_END; }
\\begin\{table\}         { return TABLE_BEGIN; }
\\end\{table\}           { return TABLE_END; }
\{                       { return BEGINBRACE; }
\}                       { return ENDBRACE; }
{newline}                { return NEWLINE; }
\\begin\{document\}      { return BEGINDOC; }
\\end\{document\}        { return ENDDOC; }
"    \\item "                { return ITEMELE; }
{table_col}              { return TABLE_COL; }
{newtext}                { yylval.str = strdup(yytext); return PLAIN_TEXT; }
[ \t\r\n]                ;
%%