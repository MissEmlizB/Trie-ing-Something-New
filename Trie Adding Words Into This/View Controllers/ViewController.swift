//
//  ViewController.swift
//  Trie Adding Words Into This
//
//  Created by Emily Blackwell on 01/12/2019.
//  Copyright © 2019 Emily Blackwell. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
	
	@IBOutlet weak var wordTextField: NSTextField!
	@IBOutlet weak var messageLabel: NSTextField!

	weak var wordTree: Trie!
	var lastTimer: Timer?
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		messageLabel.wantsLayer = true
		messageLabel.stringValue = ""
		
		let appDelegate = NSApplication.shared.delegate as! AppDelegate
		wordTree = appDelegate.wordTree
	}

	// MARK: Actions
	
	private func animateMessageLabel(reversed: Bool = false, completion: (() -> Void)? = nil) {
		
		//
		CATransaction.begin()
		CATransaction.setAnimationDuration(0.65)
		
		//
		CATransaction.setCompletionBlock(completion)
		
		//
		let transformAnimation = CASpringAnimation(keyPath: #keyPath(CALayer.transform))
		let opacityAnimation = CASpringAnimation(keyPath: #keyPath(CALayer.opacity))
		
		//
		
		if !reversed {
			transformAnimation.fromValue = CATransform3DMakeTranslation(0.0, -20.0, 0.0)
			transformAnimation.toValue = CATransform3DMakeTranslation(0.0, 0.0, 0.0)
		} else {
			transformAnimation.fromValue = CATransform3DMakeTranslation(0.0, 0.0, 0.0)
			transformAnimation.toValue = CATransform3DMakeTranslation(0.0, -20.0, 0.0)
		}
		
		//
		if !reversed {
			opacityAnimation.fromValue = 0
			opacityAnimation.toValue = 1
		} else {
			opacityAnimation.fromValue = 1
			opacityAnimation.toValue = 0
		}
		
		//
		transformAnimation.run(forKey: "transform", object: messageLabel.layer!, arguments: [:])
		opacityAnimation.run(forKey: "opacity", object: messageLabel.layer!, arguments: [:])
		
		// start our animation
		CATransaction.commit()
	}
	
	private func setMessageText(_ text: String) {
		
		//
		messageLabel.layer!.opacity = 1
		messageLabel.stringValue = text
		
		// cancel our previous "hide message label" timer
		lastTimer?.invalidate()
		
		// show the message label
		animateMessageLabel(reversed: false) {
			
			// hide the message label
			self.lastTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
				
				self.messageLabel.layer!.opacity = 0
				
				//
				self.animateMessageLabel(reversed: true) {
					self.messageLabel.stringValue = ""
				}
			}
		}
	}
	
	@IBAction func addWord(sender: AnyObject) {
		
		let word = wordTextField.stringValue
		
		if !wordTree.isValidWord(word) {
			wordTree.addWord(word)
			setMessageText("The word \"\(word)\" was added to the Trie!")
		} else {
			
			let alert = NSAlert()
			alert.messageText = "Umm..."
			alert.informativeText = "You've already added \"\(word)\" to the Trie!"
			
			alert.addButton(withTitle: "Welp, so much for Trie-ing...")
			alert.runModal()
		}
	}
	
	@IBAction func checkWord(sender: AnyObject) {
		
		let word = wordTextField.stringValue
		
		if wordTree.isValidWord(word) {
			setMessageText("Yes, the word \"\(word)\" is in the Trie!")
		} else {
			setMessageText("No, the word \"\(word)\" is not in the Trie!")
		}
	}
}

