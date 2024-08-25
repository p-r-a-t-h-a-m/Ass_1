#include "P7.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int GLOBAL_COUNTER = 1;

typedef struct treeNode *ParseTree;

struct treeNode* create_node_with_type(int case_identifier, char *type, char *text, struct treeNode *first, struct treeNode *second) {
    struct treeNode *treenode = (struct treeNode *)malloc(sizeof(struct treeNode));
    treenode->treeNodeId = case_identifier;
    treenode->treeNodetype = type;
    treenode->content = text;
    treenode->child1 = first;
    treenode->child2 = second;
    return treenode;
}

void print_ast(struct treeNode *root) {
    if (root == NULL) return;
    
    printf("Case: %d, Node Type: %s, Content: %s\n", root->treeNodeId, root->treeNodetype, root->content ? root->content : "NULL");
    
    if (root->child1 == NULL) {
        printf("END\n");
        return;
    }
    
    print_ast(root->child1);
    print_ast(root->child2);
}

void free_ast(struct treeNode *root) {
    if (!root) return;

    free(root->content);
    free_ast(root->child2);
    free_ast(root->child1);
    free(root);
}

char* markdownCode(struct treeNode *T) {
    if (T == NULL) {
        return "";
    }
    char *code = (char *)malloc(__INT16_MAX__ * sizeof(char));
    char *t1 =  (char *)malloc(__INT16_MAX__ * sizeof(char));
    char *t2 = (char *)malloc(__INT16_MAX__ * sizeof(char));
    switch (T->treeNodeId) {
        case PROGRAM:
            t1 = markdownCode(T->child1);
            sprintf(code, "%s", t1);
            break;
        case DOCUMENTS:
            if (T->treeNodetype == "recursion"){
                t1 = markdownCode(T->child1);
                t2 = markdownCode(T->child2);
                sprintf(code, "%s%s", t1, t2);
            }
            break;
        case DOC:
            if (T->treeNodetype == "recursion"){
                t1 = markdownCode(T->child1);
                t2 = markdownCode(T->child2);
                sprintf(code, "%s\n%s", t1, t2);
            }
            break;
        case SECTION:
            if (T->treeNodetype == "heading1"){
                t1 = markdownCode(T->child1);
                sprintf(code, "# %s", t1);
            }
            break;
        case SUBSECTION:
            if (T->treeNodetype == "heading2"){
                t1 = markdownCode(T->child1);
                sprintf(code, "## %s", t1);
            }
            break;
        case SUBSUBSECTION:
            if (T->treeNodetype == "heading3"){
                t1 = markdownCode(T->child1);
                sprintf(code, "### %s", t1);
            }
            break;
        case WHITESPACE:
            if (T->treeNodetype == "paragraph") {
                t1 = markdownCode(T->child1);
                sprintf(code, "%s", t1);
            } else if (T->treeNodetype == "newline") {
                sprintf(code, "\n\n");
            }
            break;
        case PLAIN_TEXT:
            if (T->treeNodetype == "text")
                sprintf(code, "%s", T->content);
            break;
        case BOLD:
            if (T->treeNodetype == "bold"){
                t1 = markdownCode(T->child1);
                sprintf(code, "**%s**", t1);
            }
            break;
        case ITALIC:
            if (T->treeNodetype == "italic"){
                t1 = markdownCode(T->child1);
                sprintf(code, "*%s*", t1);
            }
            break;
        case MONO:              // Handle MONOSPACE Node
            if (T->treeNodetype == "mono"){
                t1 = markdownCode(T->child1);
                sprintf(code, "`%s`", t1);
            }
            break;
        case HRULE:            // Handle HRULE Node
            if (T->treeNodetype == "hrule")
                sprintf(code, "\n---\n");
            break;
        case HREF:          // Handle HREF Node
            if (T->treeNodetype == "href"){
                t1 = markdownCode(T->child1);
                sprintf(code, "[%s](%s)", t1, T->content);
            }
            break;
        case IMAGE:      // Handle IMAGE Node
            if (T->treeNodetype == "image"){
                t1 = markdownCode(T->child1);
                sprintf(code, "![random_image](%s)\n", t1);
            }
            break;
        case CODE_BLOCK:        // Handle CODE BLOCK Node
            if (T->treeNodetype == "code_block"){
                t1 = markdownCode(T->child1);
                sprintf(code, "\n```\n%s\n```\n", t1);
            }
            break;
        case QUOTE_BLOCK:     // Handle QUOTE BLOCK Node
            if (T->treeNodetype == "qoute"){
                t1 = markdownCode(T->child1);
                sprintf(code, ">%s\n", t1);
            }
            break;
        case PARAGRAPH:  // Handle Paragraph Node
             if(T->treeNodetype == "paragraph"){   
                t1 = markdownCode(T->child1);
                sprintf(code, "%s\n", t1);
            }
            break;
        case LIST:
            t1 = markdownCode(T->child1);
            sprintf(code, "%s", t1);
            break;
        case ULIST_ITEMS:
            if (T->treeNodetype == "list_item") {
                t1 = markdownCode(T->child1);
                sprintf(code, "- %s\n", t1);
            } else if (T->treeNodetype == "item_recursion") {
                t1 = markdownCode(T->child1);
                t2 = markdownCode(T->child2);
                sprintf(code, "- %s\n%s", t1, t2);
            }
            break;
        case OLIST_ITEMS:
            if (T->treeNodetype == "list_item") {
                int count = GLOBAL_COUNTER;
                GLOBAL_COUNTER += 1;
                t1 = markdownCode(T->child1);
                sprintf(code, "%d. %s\n", count, t1);
            } else if (T->treeNodetype == "item_recursion") {
                int count = GLOBAL_COUNTER;
                GLOBAL_COUNTER += 1;
                t1 = markdownCode(T->child1);
                t2 = markdownCode(T->child2);
                sprintf(code, "%d. %s\n%s", count, t1, t2);
            }
            break;
    }
    return code;
}
