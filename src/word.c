#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>


// Increments the cur_input pointer while it points to whitespace
//
// cur_input: a pointer to a pointer which stores the buffer location of the
//      most recently read char in the input buffer
void eatWhitespace(char **cur_input) {
    while (isspace(**cur_input)) {
        (*cur_input)++;
    }
}

// Reads the next string from *input into *cur_word.
//
// input: the raw input buffer
// cur_input: a pointer to a pointer which stores the buffer location of the
//      most recently read char in the input buffer
// cur_word: a pointer to the current word buffer
// delimiter: the delimiter to split on
void wordC(char *input, char **cur_input, char *cur_word, char delimiter) {
    // TODO: implement delimiter functionality
    if (delimiter != 0) {
        printf("Error, delimiter not implemented\n");
        // remove stdlib include when exit is removed.
        exit(1);
    }
    eatWhitespace(cur_input);
    int i = 0;
    while (!isspace(**cur_input)) {
        cur_word[i] = **cur_input;
        (*cur_input)++;
        i++;
    }
    cur_word[i] = '\0';
}
