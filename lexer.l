%{
    #include <stdio.h>
    #include <string.h>
    extern int yyval;
%}

/* Name defined Regex */
digit       [0-9]
number      ({digit})+
alpha       [a-zA-Z]
alphaNum    [a-zA-Z0-9]
special     [\!\+/=\-\.,?`~@\$%\^&\\;:'"<>\{\}]
text        ({alpha}|[\#]{7,}|[\'\"\.\?])({alphanum}|{special}|[\#]{1,})*
space       [ ]

%%

\\section\{([^\}]+)\}           { printf("# %.*s\n", (int)(yyleng-10), yytext+9); }
\\subsection\{([^\}]+)\}        { printf("## %.*s\n", (int)(yyleng-13), yytext+12); }
\\subsubsection\{([^\}]+)\}     { printf("### %.*s\n", (int)(yyleng-16), yytext+15); }
\\textbf\{([^\}]+)\}            { printf("**%.*s**\n", (int)(yyleng-9), yytext+8); }
\\textit\{([^\}]+)\}            { printf("_%.*s_\n", (int)(yyleng-9), yytext+8); }
\\par                           { printf("PARAGRAPH\n"); }
\\begin\{itemize\}              { printf("BEGIN ITEMIZE\n"); }
\\end\{itemize\}                { printf("END ITEMIZE\n"); }
\\begin\{enumerate\}            { printf("BEGIN ENUMERATE\n"); }
\\end\{enumerate\}              { printf("END ENUMERATE\n"); }
\\item                          { printf("ITEM\n"); }
\\begin\{table\}                { printf("BEGIN TABLE\n"); }
\\end\{table\}                  { printf("END TABLE\n"); }
\\"begin\{tabular\}[^\\]+\\end\{tabular\}"   {printf("Table\n");}

\\hline                         { printf("HORIZONTAL LINE\n"); }
\\includegraphics\{([^\}]+)\}   { printf("IMAGE: %.*s\n", (int)(yyleng-18), yytext+17); }

\\href\{([^\}]+)\}\{([^\}]+)\}  { 
    int url_len = strchr(yytext + 6, '}') - (yytext + 6); 
    int text_start = url_len + 8; // The position where the text part starts
    int text_len = yyleng - 1; // Adjust length to exclude the final '}'

    printf("HYPERLINK: URL=%.*s TEXT=%.*s\n", 
           url_len, yytext + 6, 
           text_len, yytext + text_start + 1); 
}



\"([^\\"]+)\"                  { printf("QUOTE: %.*s\n", (int)(yyleng-2), yytext+1); }
\[([^\]]+)\]                    { printf("BRACKET: %.*s\n", (int)(yyleng-2), yytext+1); }
\`{3}([^`]+)\`{3}               { printf("CODE BLOCK: %.*s\n", (int)(yyleng-6), yytext+3); }
[_]{1,2}([^_]+)[_]{1,2}         { printf("UNDERLINE: %.*s\n", (int)(yyleng-2), yytext+1); }

[ \t\n]+                       { /* ignore whitespace */ }
.                              { printf("UNKNOWN CHARACTER: %s\n", yytext); }
%%

int main() {
    printf("Give me your input:\n");
    yylex();
    return 0;
}
