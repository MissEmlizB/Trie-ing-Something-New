//
//  TrieObject.m
//  Trie Adding Words Into This
//
//  Created by Emily Blackwell on 01/12/2019.
//  Copyright © 2019 Emily Blackwell. All rights reserved.
//

#import "TrieObject.h"

@implementation Trie

- (instancetype) init
{
	self = [super init];
	if (self) {
		self.wordTree = makeTrieNode();
	}
	return self;
}

- (void) reset {
	releaseTrieNode(self.wordTree);
	self.wordTree = makeTrieNode();
}

- (void) addWord: (NSString * _Nonnull) word {
	add([word UTF8String], self.wordTree);
}

- (void) addWordsFromFileWithURL:(NSURL * __nonnull) url updated: (TOUpdateBlock __nullable) updated {

	NSError *error = nil;
	NSString *fileContents = [[NSString alloc] initWithContentsOfURL: url encoding:NSUTF8StringEncoding error: &error];
	
	// why did you choose an invalid or unreadable file?
	if (error != nil || fileContents.length == 0) {
		
		if (updated != nil) {
			updated(true, 0, 0);
		}
		
		return;
	}
	
	//
	__weak Trie *weakSelf = self;
	
	//
	dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
		
		// add each lines from the file to our trie
		NSArray<NSString *> *lines = [fileContents componentsSeparatedByString: @"\n"];
		
		for (NSUInteger i = 0, l = lines.count; i < l; ++ i) {
			NSString *line = [lines objectAtIndex: i];
			
			if (line.length != 0) {
				[weakSelf addWord: line];
			}
			
			// update our progress indicator
			if (updated != nil) {
				
				dispatch_async(dispatch_get_main_queue(), ^{
					// (completed, current, max)
					updated(false, i, l);
				});
			}
		}
		
		// importing completed!
		if (updated != nil) {
			dispatch_async(dispatch_get_main_queue(), ^{
				updated(true, 0, 0);
			});
		}
	});
}

- (void)getAllWordsWithCompletion: (void (^)(NSArray<NSString *> * _Nonnull))completion {
	
	__weak Trie *weakSelf = self;
	
	//
	dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
		
		//
		NSMutableArray<NSString *> *words = [[NSMutableArray alloc] init];
		
		// find valid word paths starting at the root of our tree
		
		for (int i = 0; i < BRANCH_COUNT; ++ i) {
		
			trie_t *branch = weakSelf.wordTree->branches[i];
			
			if (branch != NULL) {
				
				NSString *path = [[NSString alloc] initWithFormat: @"%c", keyToChar(i)];
				
				// recursively follow its branches
				getWordsFromBranch(branch, &words, path);
			}
		}
		
		if (completion != nil) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(words);
			});
		}
	});
}

- (bool) isValidWord: (NSString * _Nonnull) word {
	return isValid([word UTF8String], self.wordTree);
}

- (void) dealloc
{
	__weak Trie *weakSelf = self;
	releaseTrieNode(weakSelf.wordTree);
}

// MARK: C-ish Functions

void getWordsFromBranch(trie_t * __nullable branch, NSMutableArray<NSString *> ** __nonnull array, __weak NSString * __nonnull currentPath) {
		
	if (branch == NULL) {
		return;
	}
	
	// keep following its branches until our pointers reach null
	for (int i = 0; i < BRANCH_COUNT; ++ i) {
		
		if (branch->branches[i] != NULL) {
			
			// each valid branch we follow updates our word path
			
			NSString *nextPath = [[NSString alloc] initWithFormat: @"%@%c", currentPath, keyToChar(i)];
			
			getWordsFromBranch(branch->branches[i], array, nextPath);
		}
	}
	
	// add valid paths to our word array
	if (branch->isValid) {
		[*array addObject: currentPath];
	}
}

@end
