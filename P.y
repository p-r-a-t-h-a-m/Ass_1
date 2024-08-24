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
    struct Node *node; // For AST nodes
}
 
%token SUBSECTION SUBSUBSECTION BOLD ITALIC HRULE PARAGRAPH STRT_CODE_BLOCK END_CODE_BLOCK LINK IMAGE STRT_TABLE TABLE_COL END_TABLE 
%token STRT_ITEMIZE END_ITEMIZE STRT_ENUMERATE END_ENUMERATE ITEM SECTION 
%token CURLYOPEN CURLYCLOSE NEWLINE BEGINDOC ENDDOC

%token <str> PLAIN_TEXT URL
%type <node> program documents document doc block heading formatting code_block href list ul_list_items ol_list_items image whitespace plain_text 

%%
program: BEGINDOC documents ENDDOC {
                struct Node* ParseTree;
                // printf("AST Construction begun\n");
				ParseTree = create_node_with_type("program", "begin", "", $2, NULL);
                print_ast(ParseTree);
                printf("%s", markdownCode(ParseTree));
                // free_ast(ParseTree);
                // printf("AST construction finished\n");
                }
        ;

documents : document doc 
            { 
                $$ = create_node_with_type("documents", "recursion", "", $1, $2);
            }

doc       : whitespace documents
            { 
                $$ = create_node_with_type("doc", "recursion", "", $1, $2);
            }
            | whitespace 
            {
                $$ = create_node_with_type("doc", "whitespace", "", NULL, NULL);
            }
document    : block { $$ = $1; }
            ;

block:
    heading    | formatting    | list    | code_block    | href    | image    /* | table */    | plain_text
    ;

whitespace : NEWLINE NEWLINE whitespace {$$ = create_node_with_type("whitespace", "multinewline", "", $3, NULL);}
           | NEWLINE {$$ = create_node_with_type("whitespace", "newline", "", NULL, NULL);} 
           | %empty {$$ = create_node_with_type("whitespace", "empty", "", NULL, NULL);}
           ;

heading    : SECTION CURLYOPEN documents CURLYCLOSE
            {
                $$ = create_node_with_type("section", "heading1", "", $3, NULL);
            }
            ;

            | SUBSECTION CURLYOPEN documents CURLYCLOSE
            {
                $$ = create_node_with_type("subsection", "heading2", "", $3, NULL);
            }
            ;

            | SUBSUBSECTION CURLYOPEN documents CURLYCLOSE
            {
                $$ = create_node_with_type("subsubsection", "heading3", "", $3, NULL);
            }
            ;

formatting  : BOLD CURLYOPEN documents CURLYCLOSE
            {
                $$ = create_node_with_type("bold", "bold", "", $3, NULL);
            }
            ;
            
            | ITALIC CURLYOPEN documents CURLYCLOSE
            {
                $$ = create_node_with_type("italic", "italic", "", $3, NULL); 
            }
            ;

            | PARAGRAPH
            {
                $$ = create_node_with_type("paragraph", "paragraph", "", NULL, NULL);
            }
            ;

            | HRULE
            {
                $$ = create_node_with_type("hrule", "hrule", "", NULL, NULL);
            }
            ;

code_block : STRT_CODE_BLOCK documents END_CODE_BLOCK
            {
                $$ = create_node_with_type("code_block", "code_block", "", $2,NULL);
            }
            ;

list    : 
        STRT_ITEMIZE ul_list_items END_ITEMIZE
        {
            $$ = create_node_with_type("list", "itemize", "", $2,NULL);
        }
        | STRT_ENUMERATE ol_list_items END_ENUMERATE
        {
            $$ = create_node_with_type("list", "enumerate", "", $2,NULL);
        }
        ;
ul_list_items   :
        ITEM document
        {
            $$ = create_node_with_type("ULlist_items", "list_item", "", $2,NULL);
        } 
        | ITEM document ul_list_items
        {
            $$ = create_node_with_type("ULlist_items", "list_item_recursion", "", $2,$3);
        }
        ;

ol_list_items   :
        ITEM document
        {
            $$ = create_node_with_type("OLlist_items", "list_item", "", $2,NULL);
        } 
        | ITEM document ol_list_items
        {
            $$ = create_node_with_type("OLlist_items", "list_item_recursion", "", $2,$3);
        }
        ;

  /* table:
        STRT_TABLE TABLE_COL plain_text END_TABLE
        {
            $$ = create_node_with_type("table", 0, "", $3,NULL);
        }
        ;   */

href    :
        LINK CURLYOPEN URL CURLYCLOSE CURLYOPEN documents CURLYCLOSE
        {
            $$ = create_node_with_type("href", "link", $3,$6,NULL);
        }
        ; 

image   :
        IMAGE CURLYOPEN document CURLYCLOSE
        {
            $$ = create_node_with_type("image", "image", "",$3,NULL);
        }
        ;

plain_text  :
            PLAIN_TEXT
            {
                $$ = create_node_with_type("plain_text", "text", $1, NULL, NULL);
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