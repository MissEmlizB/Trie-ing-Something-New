//
//  WordsWindowController.swift
//  Trie Adding Words Into This
//
//  Created by Emily Blackwell on 01/12/2019.
//  Copyright © 2019 Emily Blackwell. All rights reserved.
//

import Cocoa

class WordsWindowController: NSWindowController {
	
	@IBOutlet weak var searchField: NSTextField!

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
		
		// update our view controller's search text field pointer
		
		let viewController = contentViewController as! WordsViewController
		
		viewController.searchField = searchField
    }

}
