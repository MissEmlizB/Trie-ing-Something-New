//
//  WindowController.swift
//  Trie Adding Words Into This
//
//  Created by Emily Blackwell on 01/12/2019.
//  Copyright © 2019 Emily Blackwell. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
	
	@IBOutlet weak var loadingIndicator: NSProgressIndicator!
	
	weak var wordTree: Trie!
	let openPanel = NSOpenPanel()

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
				
		// get a pointer to our trie
		let appDelegate = NSApp.delegate as! AppDelegate
		wordTree = appDelegate.wordTree
		
		// set up our open panel
		openPanel.allowsMultipleSelection = false
		openPanel.resolvesAliases = true
		
		//
		loadingIndicator.isHidden = true
    }

	// MARK: Actions
	
	private func importWordsFromFile(withURL url: URL) {
		
		loadingIndicator.isHidden = false
		
		// import words from the file to our word tree
		
		wordTree.addWordsFromFile(with: url) { completed, current, max in
			
			guard !completed else {
				
				self.loadingIndicator.isHidden = true
				return
			}
						
			// update our progress indicator
			self.loadingIndicator.doubleValue = current
			self.loadingIndicator.maxValue = max
		}
	}
	
	@IBAction func loadWordsFromFile(sender: AnyObject) {
		
		openPanel.beginSheetModal(for: window!) {
			
			guard $0 == .OK, let url = self.openPanel.url else {
				return
			}
		
			self.importWordsFromFile(withURL: url)
		}
	}
}
