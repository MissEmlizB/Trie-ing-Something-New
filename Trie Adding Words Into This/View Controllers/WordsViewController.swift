//
//  WordsViewController.swift
//  Trie Adding Words Into This
//
//  Created by Emily Blackwell on 01/12/2019.
//  Copyright © 2019 Emily Blackwell. All rights reserved.
//

import Cocoa

private let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "cell")

class WordsViewController: NSViewController {
	
	@IBOutlet weak var tableView: NSTableView!
	@IBOutlet weak var loadingIndicator: NSProgressIndicator!
	@IBOutlet weak var countLabel: NSTextField!
	weak var searchField: NSTextField!
	
	var wordsArray: [String] {
		get {
			return isSearching ? filteredWords : words
		}
	}
	
	var words: [String] = []
	var filteredWords: [String] = []
	var isSearching = false
	
	weak var wordTree: Trie!

    override func viewDidLoad() {
        super.viewDidLoad()
        
		let appDelegate = NSApp.delegate as! AppDelegate
		wordTree = appDelegate.wordTree
		
		//
		tableView.dataSource = self
		tableView.delegate = self
		
		// Trie to get the current words in our tree
		getWords()
    }
	
	private func getWords() {
		
		guard loadingIndicator.isHidden else {
			return
		}
		
		//
		let rows = IndexSet(words.enumerated().map { $0.offset })
		tableView.removeRows(at: rows, withAnimation: .slideUp)
		
		words.removeAll()
		
		//
		loadingIndicator.startAnimation(self)
		loadingIndicator.isHidden = false
		
		//
		isSearching = false
		searchField?.stringValue = ""
		countLabel.stringValue = "Counting..."
		
		//
		wordTree.getAllWords {
			
			self.words = $0
			
			// insert rows into our table view
			
			let rows = IndexSet($0.enumerated().map { $0.offset })
			self.tableView.insertRows(at: rows, withAnimation: .slideDown)
			
			//
			self.loadingIndicator.stopAnimation(self)
			self.loadingIndicator.isHidden = true
			
			//
			let formatter = NumberFormatter()
			formatter.numberStyle =  .decimal
			
			self.countLabel.stringValue = "Words in trie: \(formatter.string(for: self.words.count)!)"
		}
	}
    
	// MARK: Actions
	
	@IBAction func searchTrie(sender: NSTextField) {
		
		let searchText = sender.stringValue.lowercased()
		
		guard !searchText.isEmpty else {
			isSearching = false
			tableView.reloadData()
			
			return
		}
		
		//
		isSearching = true
		
		filteredWords = words.filter {
			$0.contains(searchText)
		}
		
		tableView.reloadData()
	}
	
	@IBAction func reloadWords(sender: AnyObject) {
		getWords()
	}
}

extension WordsViewController: NSTableViewDataSource, NSTableViewDelegate {
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		return wordsArray.count
	}
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
	
		let cell = tableView.makeView(withIdentifier: cellIdentifier, owner: nil) as! NSTableCellView
		
		cell.textField!.stringValue = wordsArray[row]
		
		return cell
	}
}
