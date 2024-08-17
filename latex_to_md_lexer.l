
/* Name defined Regex */
digit       [0-9]
number      {digit}+
alpha       [a-zA-Z]
alphaNum    [a-zA-Z0-9]
punc        [\!\+/=\-\.,?@\$%\^&\\;:'"<>\{\}]
space       [ ]
text        ({alpha}|["'\.;:]|#{7,})({alphaNum}|{punc}|#{1,})*

/* LaTeX Patterns */
section     "\\section\{"[^}]+"\}"
subsection  "\\subsection\{"[^}]+"\}"
subsubsection "\\subsubsection{"[^}]+"\"}"
bold        \\"textbf{"[^}]+"\}"
italic      \\textit"{"[^}]+"\}"
hline       \\"hline"
par         \\"par"
code        \\"begin\{verbatim\}([\\s\\S]*?)\\\\end\{verbatim\}"
href        \\"href\{[^}]+\}\{[^}]+\}"
image       \\"includegraphics[^{]*\{[^}]+\}"
itemize     \\"begin\{itemize\}[^\\]+\\end\{itemize\}"
enumerate   \\"begin\{enumerate\}[^\\]+\\end\{enumerate\}"
table       \\"begin\{tabular\}[^\\]+\\end\{tabular\}"

/* Lexer Rules */
/*
*{section}         { SVAL(SECTION); }  
*{subsection}      { SVAL(SUBSECTION); }
*{subsubsection}   { SVAL(SUBSUBSECTION); }
*{bold}            { SVAL(BOLD); }
*{italic}          { SVAL(ITALIC); }
*{hline}           { LEX(HLINE); }
*{par}             { LEX(PAR); }
*{code}            { SVAL(CODE); }
*{href}            { SVAL(HREF); }
*{image}           { SVAL(IMAGE); }
*{itemize}         { SVAL(ITEMIZE); }
*{enumerate}       { SVAL(ENUMERATE); }
*{table}           { SVAL(TABLE); } 
*/

%%
{section}         { printf("SECTION"); }  
{subsection}      { printf("SUBSECTION"); }
{subsubsection}   { printf("SUBSUBSECTION"); }
{bold}            { printf("BOLD"); }
{italic}          { printf("ITALIC"); }
{hline}           { printf("HLINE"); }
{par}             { printf("PAR"); }
{code}            { printf("CODE"); }
{href}            { printf("HREF"); }
{image}           { printf("IMAGE"); }
{itemize}         { printf("ITEMIZE"); }
{enumerate}       { printf("ENUMERATE"); }
{table}           { printf("TABLE"); } 
.                 { printf("not used");}
%%

void main()
{
  printf("Give me your input:\n");
  yylex();
}