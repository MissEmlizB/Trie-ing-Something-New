//
//  trie.c
//  Trie Adding Words Into This
//
//  Created by Emily Blackwell on 01/12/2019.
//  Copyright © 2019 Emily Blackwell. All rights reserved.
//

#include "trie.h"

int charToKey(char aCharacter)
{
    char character = tolower(aCharacter);

    if (character >= 'a' && character <= 'z')
    {
        // a-z characters
        return character - 'a';
    }

    else if (character == '-')
    {
        // dashes
        return 26;
    }

    else if (character == '\'')
    {
        // apostrophes
        return 27;
    }

    else
    {
        // unknown characters
        return -1;
    }
}

trie_t *makeTrieNode()
{
    trie_t *node = malloc(sizeof(trie_t));

    if (node != NULL)
    {
        node->isValid = false;

        for (int i = 0; i < BRANCH_COUNT; ++ i)
        {
            node->branches[i] = NULL;
        }
    }

    return node;
}

void releaseTrieNode(trie_t *trie)
{
	// release its branches from memory
    for (int i = 0; i < BRANCH_COUNT; ++ i)
    {
        if (trie->branches[i] != NULL)
        {
            releaseTrieNode(trie->branches[i]);
        }
    }

	// bye bye bye
	// wait... does ARC do this for me automatically?
	
    free(trie);
}

void add(char *word, trie_t *toTrie)
{
	// segmentation faults? no thank you!
    if (word == NULL || toTrie == NULL)
    {
        return;
    }

    const unsigned long length = strlen(word);

    trie_t *pointer = toTrie;

    for (int i = 0; i < length; ++ i)
    {
        int key = charToKey(word[i]);

		// skip invalid characters
        if (key == -1)
		{
			continue;
		}

		// create new trie nodes if they're missing
        if (pointer->branches[key] == NULL)
        {
            pointer->branches[key] = makeTrieNode();
        }

		// continue following the word path
        pointer = pointer->branches[key];
    }

    pointer->isValid = true;
}

bool isValid(char *word, trie_t *inTrie)
{
    if (word == NULL || inTrie == NULL)
    {
        return false;
    }

    const unsigned long length = strlen(word);
    trie_t *pointer = inTrie;

    for (int i = 0; i < length; ++ i)
    {
        int key = charToKey(word[i]);

        if (key == -1)
		{
			continue;
		}

		// obviously, we can't follow the path if there's no path remaining.
        if (pointer->branches[key] == NULL)
        {
            return false;
        }

        pointer = pointer->branches[key];
    }

	// is this an actual word?
    return pointer->isValid;
}
