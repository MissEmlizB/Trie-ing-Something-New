//
//  TrieObject.m
//  Trie Adding Words Into This
//
//  Created by Emily Blackwell on 01/12/2019.
//  Copyright © 2019 Emily Blackwell. All rights reserved.
//

#import "TrieObject.h"

@implementation Trie

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.wordTree = makeTrieNode();
	}
	return self;
}

- (void) addWord: (NSString *) word {
	add([word UTF8String], self.wordTree);
}

- (bool) isValidWord: (NSString *) word {
	return isValid([word UTF8String], self.wordTree);
}

- (void) dealloc
{
	__weak Trie *weakSelf = self;
	releaseTrieNode(weakSelf.wordTree);
}

@end
