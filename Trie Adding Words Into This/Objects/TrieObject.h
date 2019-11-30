//
//  TrieObject.h
//  Trie Adding Words Into This
//
//  Created by Emily Blackwell on 01/12/2019.
//  Copyright © 2019 Emily Blackwell. All rights reserved.
//

#ifndef TrieObject_h
#define TrieObject_h

#import <Cocoa/Cocoa.h>
#include "trie.h"

@interface Trie : NSObject

@property trie_t *wordTree;

- (void) addWord: (NSString *) word;
- (bool) isValidWord: (NSString *) word;

@end

#endif /* TrieObject_h */
