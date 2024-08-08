%{
    #include <string.h>
    #include "latex_2md.tab.h"
%}

%option noyywrap

/* Define regular expressions for LaTeX syntax */
SECTION     \\section\{[^\}]*\}
SUBSECTION  \\subsection\{[^\}]*\}
ITALIC      \\textit\{[^\}]*\}
BOLD        \\textbf\{[^\}]*\}
HLINE       \\hline
PARAGRAPH   \\par
CODEBLOCK   \\begin\{verbatim\}(.|\n)*?\\end\{verbatim\}
HYPERLINK   \\href\{[^\}]*\}\{[^\}]*\}
IMAGE       \\includegraphics\{[^\}]*\}
ITEMIZE     \\begin\{itemize\}(.|\n)*?\\end\{itemize\}
ENUMERATE   \\begin\{enumerate\}(.|\n)*?\\end\{enumerate\}
TABLE       \\begin\{tabular\}(.|\n)*?\\end\{tabular\}

%%
{SECTION}   { yylval.str = strdup(yytext); return SECTION; }
{SUBSECTION} { yylval.str = strdup(yytext); return SUBSECTION; }
{ITALIC}    { yylval.str = strdup(yytext); return ITALIC; }
{BOLD}      { yylval.str = strdup(yytext); return BOLD; }
{HLINE}     { return HLINE; }
{PARAGRAPH} { return PARAGRAPH; }
{CODEBLOCK} { yylval.str = strdup(yytext); return CODEBLOCK; }
{HYPERLINK} { yylval.str = strdup(yytext); return HYPERLINK; }
{IMAGE}     { yylval.str = strdup(yytext); return IMAGE; }
{ITEMIZE}   { yylval.str = strdup(yytext); return ITEMIZE; }
{ENUMERATE} { yylval.str = strdup(yytext); return ENUMERATE; }
{TABLE}     { yylval.str = strdup(yytext); return TABLE; }

.           { /* ignore other characters */ }

<<EOF>>     { return 0; }

%%
