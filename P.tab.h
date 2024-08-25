/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_P_TAB_H_INCLUDED
# define YY_YY_P_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    TOKSECTION = 258,              /* TOKSECTION  */
    TOKSUBSECTION = 259,           /* TOKSUBSECTION  */
    TOKSUBSUBSECTION = 260,        /* TOKSUBSUBSECTION  */
    TOKBOLD = 261,                 /* TOKBOLD  */
    TOKITALIC = 262,               /* TOKITALIC  */
    TOKMONOSPACE = 263,            /* TOKMONOSPACE  */
    TOKHRULE = 264,                /* TOKHRULE  */
    TOKPARAGRAPH = 265,            /* TOKPARAGRAPH  */
    TOKSTRT_CODE_BLOCK = 266,      /* TOKSTRT_CODE_BLOCK  */
    TOKEND_CODE_BLOCK = 267,       /* TOKEND_CODE_BLOCK  */
    TOKLINK = 268,                 /* TOKLINK  */
    TOKIMAGE = 269,                /* TOKIMAGE  */
    TOKSTRT_ITEMIZE = 270,         /* TOKSTRT_ITEMIZE  */
    TOKEND_ITEMIZE = 271,          /* TOKEND_ITEMIZE  */
    TOKSTRT_ENUMERATE = 272,       /* TOKSTRT_ENUMERATE  */
    TOKEND_ENUMERATE = 273,        /* TOKEND_ENUMERATE  */
    TOKITEM = 274,                 /* TOKITEM  */
    TOKCURLYOPEN = 275,            /* TOKCURLYOPEN  */
    TOKCURLYCLOSE = 276,           /* TOKCURLYCLOSE  */
    TOKNEWLINE = 277,              /* TOKNEWLINE  */
    TOKBEGINDOC = 278,             /* TOKBEGINDOC  */
    TOKENDDOC = 279,               /* TOKENDDOC  */
    TOK_STRT_QOUTE = 280,          /* TOK_STRT_QOUTE  */
    TOK_END_QOUTE = 281,           /* TOK_END_QOUTE  */
    TOKPLAIN_TEXT = 282,           /* TOKPLAIN_TEXT  */
    TOKURL = 283                   /* TOKURL  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 15 "P.y"

    char *str;  // For plain text and other strings
    struct treeNode *node; // For AST nodes

#line 97 "P.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_P_TAB_H_INCLUDED  */
