#ifndef HELPER_H
#define HELPER_H

enum TreeNodeType{
    PROGRAM, DOCUMENTS, DOC, SECTION, SUBSECTION, SUBSUBSECTION, WHITESPACE, PLAIN_TEXT, BOLD, ITALIC, MONO, 
    PARAGRAPH, HRULE, HREF, IMAGE, QUOTE_BLOCK, CODE_BLOCK, LIST, ULIST_ITEMS, OLIST_ITEMS, UNKNOWN
};

struct treeNode {
    int treeNodeId;
    char *treeNodetype;
    char *content;
    struct treeNode *child1;
    struct treeNode *child2;
};

struct treeNode* create_node_with_type(int case_identifier, char *type, char *text, struct treeNode *first, struct treeNode *second);
void print_ast(struct treeNode *);
void free_ast(struct treeNode *);

#endif
