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

%token SUBSECTION SUBSUBSECTION BOLD ITALIC HLINE PAR CODE_BEGIN CODE_END HREF IMAGE TABLE_BEGIN TABLE_COL TABLE_END 
%token ITEMIZE_BEGIN ITEMIZE_END ENUMERATE_BEGIN ENUMERATE_END ITEMELE SECTION 
%token BEGINBRACE ENDBRACE NEWLINE BEGINDOC ENDDOC

%token <str> PLAIN_TEXT URL
%type <node> program documents document doc section subsection subsubsection bold italic par hline code_block href list ul_list_items ol_list_items image whitespace plain_text 

%%
program: BEGINDOC documents ENDDOC {
                struct Node* ParseTree;
                // printf("AST Construction begun\n");
				ParseTree = create_node_with_type("program", "begin", "", $2, NULL, NULL);
                print_ast(ParseTree);
                printf("%s", markdownCode(ParseTree));
                // free_ast(ParseTree);
                // printf("AST construction finished\n");
                }
        ;


/* documents : document whitespace documents 
            { 
                $$ = create_node_with_type("documents", "recursion", "", $1, $2, $3);
            }
          | %empty {$$ = create_node_with_type("documents", "empty", "", NULL, NULL, NULL);}
          ; */


documents : document doc 
            { 
                $$ = create_node_with_type("documents", "recursion", "", $1, $2, NULL);
            }

doc: whitespace documents
            { 
                $$ = create_node_with_type("doc", "recursion", "", $1, $2, NULL);
            }
        | whitespace 
        {
            $$ = create_node_with_type("doc", "whitespace", "", NULL, NULL, NULL);
        }

document:  section {$$=$1;} 
        |  subsection {$$=$1;}
        |  subsubsection  {$$=$1;}
        |  bold {$$=$1;}
        |  italic {$$=$1;}
        |  par {$$=$1;}
        |  hline {$$=$1;}
        |  code_block {$$=$1;}
        |  list {$$=$1;}
        |  href {$$=$1;} 
        |  image {$$=$1;}
        |  plain_text {$$=$1;}
        ;
        /* |  table {$$=create_node_with_type("subsection parent",1,"",$1,NULL,NULL);}  */


whitespace : NEWLINE NEWLINE whitespace {$$ = create_node_with_type("whitespace", "multinewline", "", $3, NULL, NULL);}
           | NEWLINE {$$ = create_node_with_type("whitespace", "newline", "", NULL, NULL, NULL);} 
           | %empty {$$ = create_node_with_type("whitespace", "empty", "", NULL, NULL, NULL);}
           ;

section:
        SECTION BEGINBRACE documents ENDBRACE
        {
            $$ = create_node_with_type("section", "heading1", "", $3, NULL, NULL);
        }
        ;

subsection:
        SUBSECTION BEGINBRACE documents ENDBRACE
        {
            $$ = create_node_with_type("subsection", "heading2", "", $3, NULL, NULL);
        }
        ;

subsubsection:
        SUBSUBSECTION BEGINBRACE documents ENDBRACE
        {
            $$ = create_node_with_type("subsubsection", "heading3", "", $3, NULL, NULL);
        }
        ;

bold:
        BOLD BEGINBRACE documents ENDBRACE
        {
            $$ = create_node_with_type("bold", "bold", "", $3, NULL, NULL);
        }
        ;

italic:
        ITALIC BEGINBRACE documents ENDBRACE
        {
            $$ = create_node_with_type("italic", "italic", "", $3, NULL, NULL); 
        }
        ;

par:
        PAR
        {
            $$ = create_node_with_type("para", "para", "", NULL, NULL, NULL);
        }
        ;

hline:
        HLINE
        {
            $$ = create_node_with_type("hrule", "hrule", "", NULL, NULL, NULL);
        }
        ;

code_block:
        CODE_BEGIN documents CODE_END
        {
            $$ = create_node_with_type("code_block", "code_block", "", $2,NULL,NULL);
        }
        ;

list: 
        ITEMIZE_BEGIN ul_list_items ITEMIZE_END
        {
            $$ = create_node_with_type("list", "itemize", "", $2,NULL,NULL);
        }
        | ENUMERATE_BEGIN ol_list_items ENUMERATE_END
        {
            $$ = create_node_with_type("list", "enumerate", "", $2,NULL,NULL);
        }
        ;
ul_list_items:
        ITEMELE document
        {
            $$ = create_node_with_type("ULlist_items", "list_item", "", $2,NULL,NULL);
        } 
        | ITEMELE document ul_list_items
        {
            $$ = create_node_with_type("ULlist_items", "list_item_recursion", "", $2,$3,NULL);
        }
        ;

ol_list_items:
        ITEMELE document
        {
            $$ = create_node_with_type("OLlist_items", "list_item", "", $2,NULL,NULL);
        } 
        | ITEMELE document ol_list_items
        {
            $$ = create_node_with_type("OLlist_items", "list_item_recursion", "", $2,$3,NULL);
        }
        ;

  /* table:
        TABLE_BEGIN TABLE_COL plain_text TABLE_END
        {
            $$ = create_node_with_type("table", 0, "", $3,NULL,NULL);
        }
        ;   */

href:
        HREF BEGINBRACE URL ENDBRACE BEGINBRACE documents ENDBRACE
        {
            $$ = create_node_with_type("href", "link", $3,$6,NULL,NULL);
        }
        ; 

image:
        IMAGE BEGINBRACE documents ENDBRACE
        {
            $$ = create_node_with_type("image", "image", "",$3,NULL,NULL);
        }
        ;

plain_text:
        PLAIN_TEXT
        {
            $$ = create_node_with_type("plain_text", "text", $1, NULL, NULL, NULL);
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
