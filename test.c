/**
 * @file test.c
 * @brief Unit tests for the Markdown parser using CUnit.
 * 
 * This file contains the unit tests for a Markdown parser. 
 * The tests check the conversion of various LaTeX-like structures (sections, subsections, bold, italic, image,  etc.) 
 * into their corresponding Markdown representations.
 * 
 * The tests use the CUnit testing framework.
 */
#include <CUnit/CUnit.h>
#include <CUnit/Basic.h>
#include <CUnit/TestRun.h>
#include "P7.c"

/**
 * @brief Test conversion of LaTeX section to Markdown heading level 1.
 */


void test_section() {
    struct treeNode *node1 = create_node_with_type(PLAIN_TEXT, "text", "Section content", NULL, NULL);
    struct treeNode *node = create_node_with_type(SECTION, "heading1", "", node1, NULL);
    char *result = markdownCode(node);
    
    CU_ASSERT_STRING_EQUAL_FATAL(result, "# Section content");
    free(result);
}

void test_section_with_formatting() {
    struct treeNode *italicNode = create_node_with_type(ITALIC, "italic", "", create_node_with_type(PLAIN_TEXT, "text", "Italic content", NULL, NULL), NULL);
    struct treeNode *boldNode = create_node_with_type(BOLD, "bold", "", italicNode, NULL);
    struct treeNode *node = create_node_with_type(SECTION, "heading1", "", boldNode, NULL);
    char *result = markdownCode(node);
    CU_ASSERT_STRING_EQUAL_FATAL(result, "# ***Italic content***");
    free(result);
}

void test_empty_section() {
    struct treeNode *node = create_node_with_type(SECTION, "heading1", "", NULL, NULL);
    char *result = markdownCode(node);
    CU_ASSERT_STRING_EQUAL_FATAL(result, "# ");
    free(result);
}

/**
 * @brief Test conversion of LaTeX subsection to Markdown heading level 2.
 */

void test_subsection() {
    struct treeNode *node1 = create_node_with_type(PLAIN_TEXT,"text","this is a text",NULL,NULL);
    struct treeNode *node = create_node_with_type(SUBSECTION, "heading2", "", node1, NULL);
    char *result = markdownCode(node);
    CU_ASSERT_STRING_EQUAL_FATAL(result, "## this is a text");
    free(result);
}
void test_empty_subsection() {
    struct treeNode *node = create_node_with_type(SUBSECTION, "heading2", "", NULL, NULL);
    char *result = markdownCode(node);
    CU_ASSERT_STRING_EQUAL_FATAL(result, "## ");
    free(result);
}


/**
 * @brief Test conversion of LaTeX subsubsection to Markdown heading level 3.
 */
void test_subsubsection() {
    struct treeNode *node1 = create_node_with_type(PLAIN_TEXT,"text","this is a text",NULL,NULL);
    struct treeNode *node = create_node_with_type(SUBSUBSECTION, "heading3", "", node1, NULL);
    char *result = markdownCode(node);
    CU_ASSERT_STRING_EQUAL_FATAL(result, "### this is a text");
    free(result);
}
void test_empty_subsubsection() {
    struct treeNode *node = create_node_with_type(SUBSUBSECTION, "heading3", "", NULL, NULL);
    char *result = markdownCode(node);
    CU_ASSERT_STRING_EQUAL_FATAL(result, "### ");
    free(result);
}

/**
 * @brief Test conversion of bold text.
 */
void test_bold() {
    struct treeNode *node1 = create_node_with_type(PLAIN_TEXT,"text","this is a text",NULL,NULL);
    struct treeNode *node = create_node_with_type(BOLD, "bold", "", node1, NULL);
    char *result = markdownCode(node);
    CU_ASSERT_STRING_EQUAL_FATAL(result, "**this is a text**");
    free(result);
}

/**
 * @brief Test conversion of italic text.
 */

void test_italic() {
    struct treeNode *node1 = create_node_with_type(PLAIN_TEXT,"text","this is a text",NULL,NULL);
    struct treeNode *node = create_node_with_type(ITALIC, "italic", "", node1, NULL);
    char *result = markdownCode(node);
    CU_ASSERT_STRING_EQUAL_FATAL(result, "*this is a text*");
    free(result);
}

/**
 * @brief Test conversion of bold and italic text combined.
 */

void test_bold_with_italic() {
    struct treeNode *node1 = create_node_with_type(PLAIN_TEXT,"text","this is a text",NULL,NULL);
    struct treeNode *boldNode = create_node_with_type(BOLD, "bold", "", node1, NULL);
    struct treeNode *italicNode = create_node_with_type(ITALIC, "italic", "", boldNode, NULL);
    char *result = markdownCode(italicNode);
    CU_ASSERT_STRING_EQUAL_FATAL(result, "***this is a text***");
    free(result);
}

void test_monospace() {
    struct treeNode *node1 = create_node_with_type(PLAIN_TEXT, "text", "monospace text", NULL, NULL);
    struct treeNode *node = create_node_with_type(MONO, "mono", "", node1, NULL);
    char *result = markdownCode(node);
    CU_ASSERT_STRING_EQUAL_FATAL(result, "`monospace text`");
    free(result);
}


int main() {
    CU_initialize_registry();

    CU_pSuite suite = CU_add_suite("ParserTestSuite", 0, 0);

    CU_add_test(suite, "test_section", test_section);
    CU_add_test(suite, "test_section_with_formatting", test_section_with_formatting);
    CU_add_test(suite, "test_empty_section", test_empty_section);
    CU_add_test(suite, "test_subsection", test_subsection);
    CU_add_test(suite, "test_empty_subsection", test_empty_subsection);
    CU_add_test(suite, "test_subsubsection", test_subsubsection);
    CU_add_test(suite, "test_empty_subsubsection", test_empty_subsubsection);
    CU_add_test(suite, "test_bold", test_bold);
    CU_add_test(suite, "test_italic", test_italic);
    CU_add_test(suite, "test_bold_with_italic", test_bold_with_italic);
    CU_add_test(suite, "test_monospace", test_monospace);

    CU_basic_set_mode(CU_BRM_VERBOSE);
    CU_basic_run_tests();
    CU_cleanup_registry();

    return 0;
}