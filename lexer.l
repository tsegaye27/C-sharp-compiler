%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h" // Include the generated header file from Bison
extern YYSTYPE yylval;
%}

%option noyywrap

%{
// Function to print tokens
void printToken(int tokenType, const char* lexeme) {
    printf("%d(\"%s\");\n", tokenType, lexeme);
}

const char* keywords[] = {
    "abstract", "as", "base", "bool", "break", "byte", "case", "catch", "char", "checked",
    "class", "const", "continue", "decimal", "default", "delegate", "do", "double", "else",
    "enum", "event", "explicit", "extern", "false", "finally", "fixed", "float", "for", "foreach",
    "goto", "if", "implicit", "in", "int", "interface", "internal", "is", "lock", "long", "namespace",
    "new", "null", "object", "operator", "out", "override", "params", "private", "protected", "public",
    "readonly", "ref", "return", "sbyte", "sealed", "short", "sizeof", "stackalloc", "static", "string",
    "struct", "switch", "this", "throw", "true", "try", "typeof", "uint", "ulong", "unchecked", "unsafe",
    "ushort", "using", "using static", "virtual", "void", "volatile", "while"
};

// Function to check if a given string is a keyword
int isKeyword(const char* word) {
    int numKeywords = sizeof(keywords) / sizeof(keywords[0]);
    for (int i = 0; i < numKeywords; ++i) {
        if (strcmp(word, keywords[i]) == 0) {
            return 1; // Keyword found
        }
    }
    return 0; // Not a keyword
}
%}

%%

[ \t\n]+           /* Ignore whitespace */
\/\/[^\n]*         { /* Ignore single-line comments */ }
\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*\/  { /* Ignore multi-line comments */ }

[a-zA-Z_][a-zA-Z0-9_]* {
    // Check if the identifier is a keyword
    if (isKeyword(yytext)) {
        yylval.str = strdup(yytext);
        return KEYWORD;
    } else {
        yylval.str = strdup(yytext);
        return IDENTIFIER;
    }
}

\"([^\"\\]|\\.)*\"     { yylval.str = strdup(yytext); return STRING; }
[0-9]+                 { yylval.str = strdup(yytext); return NUMBER; }
[()\[\]{};:,.?\/!%@#"'] { yylval.str = strdup(yytext); return PUNCTUATION; }
[+\-*/%=<>!&|^?:,]|"=="|"->"|"=>" { yylval.str = strdup(yytext); return OPERATOR; }
.                       { yylval.str = strdup(yytext); return UNKNOWN; } // Handle unrecognized tokens

%%

#undef yywrap

int yywrap() {
    return 1; // Indicate end of input
}
