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

\\section                { return SECTION; }
\\subsection             { return SUBSECTION; }
\\subsubsection          { return SUBSUBSECTION; }
\\textbf                 { yylval.str = strdup(yytext); return BOLD; }
\\textit                 { yylval.str = strdup(yytext); return ITALIC; }
\\hrule                  { return HRULE; }
\\par                    { return PARAGRAPH; }
\\begin\{verbatim\}      { return STRT_CODE_BLOCK; }
\\end\{verbatim\}        { return END_CODE_BLOCK; }
\\href                   { return LINK; }
{url}                    { yylval.str = strdup(yytext); return URL; }
\\includegraphics        { return IMAGE; }
\\begin\{itemize\}       { return STRT_ITEMIZE; }
\\end\{itemize\}         { return END_ITEMIZE; }
\\begin\{enumerate\}     { return STRT_ENUMERATE; }
\\end\{enumerate\}       { return END_ENUMERATE; }
\\begin\{table\}         { return STRT_TABLE; }
\\end\{table\}           { return END_TABLE; }
\{                       { return CURLYOPEN; }
\}                       { return CURLYCLOSE; }
{newline}                { return NEWLINE; }
\\begin\{document\}      { return BEGINDOC; }
\\end\{document\}        { return ENDDOC; }
"    \\item "            { return ITEM; }
{table_col}              { return TABLE_COL; }
{newtext}                { yylval.str = strdup(yytext); return PLAIN_TEXT; }
[ \n\t\r]                ;
%%