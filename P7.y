%{
#include "P7.h"

ASTNode *root;

%}

%union {
    char *string;
    ASTNode *node;
}

%token <string> TEXT SECTION SUBSECTION SUBSUBSECTION TEXTBF TEXTIT PAR ITEMIZE ENUMERATE ITEM TABLE TABULAR HLINE INCLUDEGRAPHICS HREF QUOTE BRACKET CODEBLOCK UNDERLINE

%type <node> document section subsection subsubsection textbf textit paragraph itemize enumerate item table tabular hline includegraphics href quote bracket codeblock underline text

%%

document
    : section document { root = $1; addChildNode($1, $2); }
    | /* empty */       { root = createNode(NODE_TEXT, NULL); }
    ;

section
    : SECTION TEXT { $$ = createNode(NODE_SECTION, $2); }
    ;

subsection
    : SUBSECTION TEXT { $$ = createNode(NODE_SUBSECTION, $2); }
    ;

subsubsection
    : SUBSUBSECTION TEXT { $$ = createNode(NODE_SUBSUBSECTION, $2); }
    ;

textbf
    : TEXTBF TEXT { $$ = createNode(NODE_TEXTBF, $2); }
    ;

textit
    : TEXTIT TEXT { $$ = createNode(NODE_TEXTIT, $2); }
    ;

paragraph
    : PAR { $$ = createNode(NODE_PARAGRAPH, NULL); }
    ;

itemize
    : ITEMIZE { $$ = createNode(NODE_ITEMIZE, NULL); }
    ;

enumerate
    : ENUMERATE { $$ = createNode(NODE_ENUMERATE, NULL); }
    ;

item
    : ITEM { $$ = createNode(NODE_ITEM, NULL); }
    ;

table
    : TABLE { $$ = createNode(NODE_TABLE, NULL); }
    ;

tabular
    : TABULAR { $$ = createNode(NODE_TABULAR, NULL); }
    ;

hline
    : HLINE { $$ = createNode(NODE_HLINE, NULL); }
    ;

includegraphics
    : INCLUDEGRAPHICS TEXT { $$ = createNode(NODE_INCLUDEGRAPHICS, $2); }
    ;

href
    : HREF TEXT { $$ = createNode(NODE_HREF, $2); }
    | HREF TEXT TEXT { 
        // Assuming the first TEXT is the URL and the second is the link text
        char *combined = (char *)malloc(strlen($2) + strlen($3) + 10);
        sprintf(combined, "[%s](%s)", $3, $2);
        $$ = createNode(NODE_HREF, combined); 
    }
    ;


quote
    : QUOTE TEXT { $$ = createNode(NODE_QUOTE, $2); }
    ;

bracket
    : BRACKET TEXT { $$ = createNode(NODE_BRACKET, $2); }
    ;

codeblock
    : CODEBLOCK TEXT { $$ = createNode(NODE_CODEBLOCK, $2); }
    ;

underline
    : UNDERLINE TEXT { $$ = createNode(NODE_UNDERLINE, $2); }
    ;

text
    : TEXT { $$ = createNode(NODE_TEXT, $1); }
    ;

%%
