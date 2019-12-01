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

// Trie Object update block (completed, current, max)
typedef void (^TOUpdateBlock)(bool, double, double);

@interface Trie : NSObject

@property trie_t * _Nonnull wordTree;

- (void) reset;

- (void) addWord: (NSString * _Nonnull) word;
- (bool) isValidWord: (NSString * _Nonnull) word;

- (void) addWordsFromFileWithURL: (NSURL * __nonnull) url updated: (TOUpdateBlock __nullable) updated;

- (void) getAllWordsWithCompletion: (void (^ __nullable)(NSArray<NSString *> * _Nonnull)) completion;

// C-ish functions

void getWordsFromBranch(trie_t * __nullable branch, NSMutableArray<NSString *> ** __nonnull array, __weak NSString * __nonnull currentPath);

@end

#endif /* TrieObject_h */
