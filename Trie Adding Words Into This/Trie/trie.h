//
//  trie.h
//  Trie Adding Words Into This
//
//  Created by Emily Blackwell on 01/12/2019.
//  Copyright © 2019 Emily Blackwell. All rights reserved.
//

#ifndef _TRIE_H_
#define _TRIE_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>

#define BRANCH_COUNT 28

typedef struct IfYouNeverTrieYouFailEveryTime
{
    bool isValid;
    struct IfYouNeverTrieYouFailEveryTime *branches[BRANCH_COUNT];
}
trie_t;

int charToKey(char aCharacter);
char keyToChar(int key);

trie_t *makeTrieNode(void);
void releaseTrieNode(trie_t *trie);
void add(char *word, trie_t *toTrie);
bool isValid(char *word, trie_t *inTrie);

#endif
