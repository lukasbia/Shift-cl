#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TOKEN_VARIABLE 1
#define TOKEN_CONSTANT 2
#define TOKEN_FUNC     3
#define TOKEN_IDENTIFIER 99

int run_lexer(const char *source, int *tokens, int *token_count) {
    int cursor = 0;
    int t_idx = 0;

    while (source[cursor] != '\0') {
        if (source[cursor] == '<') {
            while (source[cursor] != '\0' && source[cursor] != '\n') {
                cursor++;
            }
        } else if (source[cursor] == ' ' || source[cursor] == '\t' || source[cursor] == '\n') {
            cursor++;
        } else if (strncmp(&source[cursor], "variable", 8) == 0) {
            tokens[t_idx++] = TOKEN_VARIABLE;
            cursor += 8;
        } else if (strncmp(&source[cursor], "constant", 8) == 0) {
            tokens[t_idx++] = TOKEN_CONSTANT;
            cursor += 8;
        } else if (strncmp(&source[cursor], "func", 4) == 0) {
            tokens[t_idx++] = TOKEN_FUNC;
            cursor += 4;
        } else if ((source[cursor] >= 'a' && source[cursor] <= 'z') || (source[cursor] >= 'A' && source[cursor] <= 'Z')) {
            tokens[t_idx++] = TOKEN_IDENTIFIER;
            while ((source[cursor] >= 'a' && source[cursor] <= 'z') || 
                   (source[cursor] >= 'A' && source[cursor] <= 'Z') || 
                   (source[cursor] >= '0' && source[cursor] <= '9')) {
                cursor++;
            }
        } else {
            cursor++;
        }
    }

    *token_count = t_idx;
    return 0;
}
