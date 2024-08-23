%{
#include "P7.tab.h"
#include "P7.h"
%}

/* Regular expression definitions */
digit                   [0-9]
alpha                   [a-zA-Z]
alphaNum                [a-zA-Z0-9]
special                 [\!\+/=\-\.,?`~@\$%\^&\\;:'"<>\{\}]
space                   [ ]
text                    ({alphaNum}|{special})*
newtext                 {text}({space}{text})*
newline                 \\n
plain_text              [^\\{}]+
table_col               \{|c|[c|]*\}
%%

\\section                { yylval.str = strdup(yytext); return SECTION; }
\\subsection             { yylval.str = strdup(yytext); return SUBSECTION; }
\\subsubsection          { yylval.str = strdup(yytext); return SUBSUBSECTION; }
\\textbf                 { yylval.str = strdup(yytext); return BOLD; }
\\textit                 { yylval.str = strdup(yytext); return ITALIC; }
\\hline                  { return HLINE; }
\\par                    { return PAR; }
\\begin\{verbatim\}      { return CODE_BEGIN; }
\\end\{verbatim\}        { return CODE_END; }
\\href                   { yylval.str = strdup(yytext); return HREF; }
\\includegraphics        { yylval.str = strdup(yytext); return IMAGE; }
\\begin\{itemize\}       { return ITEMIZE_BEGIN; }
\\end\{itemize\}         { return ITEMIZE_END; }
\\begin\{enumerate\}     { return ENUMERATE_BEGIN; }
\\end\{enumerate\}       { return ENUMERATE_END; }
\\begin\{table\}         { return TABLE_BEGIN; }
\\end\{table\}           { return TABLE_END; }
\{                       { return BEGINBRACE; }
\}                       { return ENDBRACE; }
{plain_text}             { yylval.str = strdup(yytext); return PLAIN_TEXT; }
{newline}                { return NEWLINE; }
\\begin\{document\}      { return BEGINDOC; }
\\end\{document\}        { return ENDDOC; }
"\\item "                { return ITEMELE; }
{table_col}              { return TABLE_COL; }
{newtext}                { yylval.str = strdup(yytext); return PLAIN_TEXT; }

%%

int yywrap(void) {
    return 1;
}
