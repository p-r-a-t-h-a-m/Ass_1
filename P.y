%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "P7.h"
#include "P7.c"

// Function prototypes
int yylex(void);
void yyerror(char *s);

%}
%start program

%union {
    char *str;  // For plain text and other strings
    struct treeNode *node; // For AST nodes
}


%token TOKSECTION TOKSUBSECTION TOKSUBSUBSECTION TOKBOLD TOKITALIC TOKMONOSPACE TOKHRULE TOKPARAGRAPH TOKSTRT_CODE_BLOCK TOKEND_CODE_BLOCK TOKLINK TOKIMAGE /*STRT_TABLE TABLE_COL END_TABLE ROW_STRT ROW_END*/
%token TOKSTRT_ITEMIZE TOKEND_ITEMIZE TOKSTRT_ENUMERATE TOKEND_ENUMERATE TOKITEM /*STRT_TABULAR END_TABULAR*/
%token TOKCURLYOPEN TOKCURLYCLOSE TOKNEWLINE TOKBEGINDOC TOKENDDOC TOK_STRT_QOUTE TOK_END_QOUTE/*SEPARATOR*/

%token <str> TOKPLAIN_TEXT TOKURL
%type <node> program documents document doc block heading formatting code_block href list ul_list_items ol_list_items image /*table column_spec row rows column columns */whitespace plain_text 

%%
program: TOKBEGINDOC documents TOKENDDOC {
                struct treeNode* ParseTree;
                // printf("AST Construction begun\n");
				ParseTree = create_node_with_type(PROGRAM, "begin", "", $2, NULL);
                // print_ast(ParseTree);
                printf("%s", markdownCode(ParseTree));
                // free_ast(ParseTree);
                // printf("AST construction finished\n");
                }
        ;

documents : document doc 
            { 
                $$ = create_node_with_type(DOCUMENTS, "recursion", "", $1, $2);
            }

doc       : whitespace documents
            { 
                $$ = create_node_with_type(DOC, "recursion", "", $1, $2);
            }
            | whitespace 
            {
                $$ = create_node_with_type(DOC, "whitespace", "", NULL, NULL);
            }
document    : block { $$ = $1; }
            ;

block:
    heading    | formatting    | list    | code_block    | href    | image  /*| table*/    | plain_text
    ;

whitespace : TOKNEWLINE TOKNEWLINE whitespace {$$ = create_node_with_type(WHITESPACE, "paragraph", "", $3, NULL);}
           | TOKNEWLINE {$$ = create_node_with_type(WHITESPACE, "newline", "", NULL, NULL);} 
           | %empty {$$ = create_node_with_type(WHITESPACE, "empty", "", NULL, NULL);}
           ;

heading    : TOKSECTION TOKCURLYOPEN documents TOKCURLYCLOSE
            {
                $$ = create_node_with_type(SECTION, "heading1", "", $3, NULL);
            }
            | TOKSUBSECTION TOKCURLYOPEN documents TOKCURLYCLOSE
            {
                $$ = create_node_with_type(SUBSECTION, "heading2", "", $3, NULL);
            }

            | TOKSUBSUBSECTION TOKCURLYOPEN documents TOKCURLYCLOSE
            {
                $$ = create_node_with_type(SUBSUBSECTION, "heading3", "", $3, NULL);
            }
            ;

formatting  : TOKBOLD TOKCURLYOPEN documents TOKCURLYCLOSE
            {
                $$ = create_node_with_type(BOLD, "bold", "", $3, NULL);
            }
            | TOKITALIC TOKCURLYOPEN documents TOKCURLYCLOSE
            {
                $$ = create_node_with_type(ITALIC, "italic", "", $3, NULL); 
            }
            | TOKMONOSPACE TOKCURLYOPEN documents TOKCURLYCLOSE
            {
                $$ = create_node_with_type(MONO, "mono", "", $3, NULL);
            }
            | TOK_STRT_QOUTE documents TOK_END_QOUTE
            {
                $$ = create_node_with_type(QUOTE_BLOCK, "qoute", "", $2, NULL);
            }
            | TOKPARAGRAPH
            {
                $$ = create_node_with_type(PARAGRAPH, "paragraph", "", NULL, NULL);
            }
            | TOKHRULE
            {
                $$ = create_node_with_type(HRULE, "hrule", "", NULL, NULL);
            }
            ;

code_block : TOKSTRT_CODE_BLOCK documents TOKEND_CODE_BLOCK
            {
                $$ = create_node_with_type(CODE_BLOCK, "code_block", "", $2,NULL);
            }
            ;

list    : 
        TOKSTRT_ITEMIZE ul_list_items TOKEND_ITEMIZE
        {
            $$ = create_node_with_type(LIST, "itemize", "", $2,NULL);
        }
        | TOKSTRT_ENUMERATE ol_list_items TOKEND_ENUMERATE
        {
            $$ = create_node_with_type(LIST, "enumerate", "", $2,NULL);
        }
        ;
ul_list_items   :
        TOKITEM document
        {
            $$ = create_node_with_type(UL_LIST_ITEMS, "list_item", "", $2,NULL);
        } 
        | TOKITEM document ul_list_items
        {
            $$ = create_node_with_type(UL_LIST_ITEMS, "list_item_recursion", "", $2,$3);
        }
        ;

ol_list_items   :
        TOKITEM document
        {
            $$ = create_node_with_type(OL_LIST_ITEMS, "list_item", "", $2,NULL);
        } 
        | TOKITEM document ol_list_items
        {
            $$ = create_node_with_type(OL_LIST_ITEMS, "list_item_recursion", "", $2,$3);
        }
        ;

/* table:
        STRT_TABLE TABLE_COL plain_text END_TABLE
        {
            $$ = create_node_with_type("table", 0, "", $3,NULL);
        }
        ;   */
/* table:
    STRT_TABLE STRT_TABULAR column_spec rows END_TABULAR END_TABLE
    {
        $$ = create_node_with_type("table", "complete", "", $3, $4);
        printf("%s", markdownCode($$));
        free_ast($$);
    }
    ;

column_spec:
    /* Matches column specification inside \begin{tabular}{} */
    /* For example, |c|c| 
    PLAIN_TEXT
    {
        $$ = create_node_with_type("column_spec", "spec", 0, $1, NULL);
    }
    ;

rows:
    row rows
    {
        $$ = create_node_with_type("rows", "recursion", "", $1, $2);
    }
    | %empty
    {
        $$ = NULL;
    }
    ;

row:
    ROW_STRT columns ROW_END
    {
        $$ = create_node_with_type("row", "complete", "", $2, NULL);
    }
    ;

columns:
    column SEPARATOR columns
    {
        $$ = create_node_with_type("columns", "recursion", "", $1, $3);
    }
    | column
    {
        $$ = create_node_with_type("columns", "single", "", $1, NULL);
    }
    ;

column:
    PLAIN_TEXT
    {
        $$ = create_node_with_type("column", "data",0,  $1, NULL);
    }
    ; */



href    :
        TOKLINK TOKCURLYOPEN TOKURL TOKCURLYCLOSE TOKCURLYOPEN documents TOKCURLYCLOSE
        {
            $$ = create_node_with_type(HREF, "link", $3,$6,NULL);
        }
        ; 

image   :
        TOKIMAGE TOKCURLYOPEN document TOKCURLYCLOSE
        {
            $$ = create_node_with_type(IMAGE, "image", "",$3,NULL);
        }
        ;

plain_text  :
            TOKPLAIN_TEXT
            {
                $$ = create_node_with_type(PLAIN_TEXT, "text", $1, NULL, NULL);
            }
            ;
%%

void yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() { 
    yyparse();
    return 0;
}