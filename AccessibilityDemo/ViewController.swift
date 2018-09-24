//
//  ViewController.swift
//  AccessibilityDemo
//
//  Created by Leo on 6/29/18.
//  Copyright © 2018 jpmc. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITextViewDelegate, WKNavigationDelegate {
	
	@IBOutlet var label: UILabel!
	@IBOutlet var textView: UITextView!
	@IBOutlet var dockWebView: UIView!
	private var webView: WKWebView!

	override func viewDidLoad() {
		super.viewDidLoad()
		setupTextView()
		setupWebView()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

/*
	private func setupTextView() {
		//	Format the link
		let linkAttributes: [NSAttributedStringKey: Any] = [
			.link: NSURL(string: "jpmc://my-action1")!,
			.foregroundColor: UIColor.yellow
		]

		let attributedString = NSMutableAttributedString(string: "Just click here to test the link. Once the link is tapped, the link above will be updated.")

		//	Set the 'click here' substring to be the link
		attributedString.setAttributes(linkAttributes, range: NSMakeRange(5, 10))

		textView.delegate = self
		textView.attributedText = attributedString
		textView.isUserInteractionEnabled = true
		textView.isEditable = false
	}
*/

	///	UITextItemInteraction is only available in iOS 10.0+, 
	///	for compatibility use `func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool` instead
	func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
		print("TEXTVIEW url: \(URL)")

		//	Change something in the UI so that we know the link is tapped
		let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:MM:ss"
		label.text = "UITextView tapped at: " + dateFormatter.string(from: Date())

		return false
	}

	private func setupWebView() {
		webView = WKWebView()
		webView.navigationDelegate = self
		dockWebView.addSubview(webView)

		webView.translatesAutoresizingMaskIntoConstraints = false
		webView.leadingAnchor.constraint(equalTo: dockWebView.leadingAnchor, constant: 8).isActive = true
		webView.trailingAnchor.constraint(equalTo: dockWebView.trailingAnchor, constant: -8).isActive = true
		webView.topAnchor.constraint(equalTo: dockWebView.topAnchor, constant: 8).isActive = true
		webView.bottomAnchor.constraint(equalTo: dockWebView.bottomAnchor, constant: -8).isActive = true

		//	Localizable string should not be mixed with HTML/CSS contents
		let content = NSLocalizedString("This is a webview, and in side this H1 tag, here is a <a href=\"jpmc://my-action2\">link</a> that you can click.", comment: "html contents")
		webView.loadHTMLString("<html><head><style>\(css)</style></head><body><h1>\(content)</h1></body></html>", baseURL: nil)
	}

	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping ((WKNavigationActionPolicy) -> Void)) {
		print("WEBVIEW action: \(navigationAction)")

		//	Change something in the UI so that we know the link is tapped
		let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:MM:ss"
		label.text = "WKWebView tapped at: " + dateFormatter.string(from: Date())

		decisionHandler(.allow)
	}

    private func setupTextView() {
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.clear
        textView.isEditable = false
        textView.isSelectable = true
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainerInset = UIEdgeInsets.zero;
        textView.textContainer.lineFragmentPadding = 0;
        
        let white = UIColor.black
       
		let rawText = "Investment products and services are offered through J.P. Morgan Securities LLC (JPMS), a Member of FINRA and SIPC."
		let font = UIFont.systemFont(ofSize: 16)
        if let sRange = rawText.range(of: "FINRA"),
            let fRange = rawText.range(of: "SIPC") {
            let attributedString = NSMutableAttributedString(string: rawText)
            
			attributedString.addAttribute(NSAttributedStringKey.link , value: "http://google.com", range: NSRange(sRange, in: rawText))
			attributedString.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(sRange, in: rawText))
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor , value: white, range: NSRange(sRange, in: rawText))
            
            attributedString.addAttribute(NSAttributedStringKey.link , value: "http://apple.com", range: NSRange(fRange, in: rawText))
            attributedString.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(fRange, in: rawText))
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor , value: white, range: NSRange(fRange, in: rawText))
			
			attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: white, range: NSRange(rawText.startIndex..<rawText.endIndex, in: rawText))
			attributedString.addAttribute(NSAttributedStringKey.font, value: font, range: NSRange(rawText.startIndex..<rawText.endIndex, in: rawText))
			//attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: white, range: NSRange(rawText.range(from: rawText.startIndex..<rawText.endIndex), in: rawText))
            
            textView.attributedText = attributedString
            textView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: white]
            
        } else {
            textView.textColor = white
            textView.text = "WARNING"
        }
        textView.sizeToFit()
    }
}

class AutoTableController: UIViewController {
	@IBOutlet var table: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()
        //table.estimatedRowHeight = UITableViewAutomaticDimension
		table.reloadData()
		DispatchQueue.main.async {
			//self.table.reloadData()
		}
	}
}
    
extension AutoTableController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		//if indexPath.section == 0 { return 188 }
        return UITableViewAutomaticDimension
    }
}

extension AutoTableController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		} else if section == 1 {
			return 2
		}
		return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicCollectionCell") as! DynamicCollectionCell
            cell.collection.reloadData()
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
			return cell
		}
		if indexPath.section == 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicStackCell") as! DynamicStackCell
			for i in 0 ..< indexPath.row {
				let label = UILabel()
                label.text = "line \(i + 2)"
				cell.stack.addArrangedSubview(label)
			}
			return cell
		}

		let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicLabelCell") as! DynamicLabelCell
        cell.label.text = "line 1"
        for i in 0 ..< indexPath.row {
            cell.label.text! += "\nline \(i + 2)"
        }
		return cell
    }
}

class DynamicLabelCell: UITableViewCell {
	@IBOutlet var label: UILabel!
    override func layoutSubviews() {
        super.layoutSubviews()
        //print("label cell: \(frame.height)")
    }
}

class DynamicStackCell: UITableViewCell {
	@IBOutlet var stack: UIStackView!
    override func layoutSubviews() {
        super.layoutSubviews()
        //print("stack cell: \(frame.height)")
    }
}

class DynamicCollectionCell: UITableViewCell {
	@IBOutlet var collection: UICollectionView!
    override func layoutSubviews() {
        super.layoutSubviews()
        print("collection cell 1: \(frame.height)")
		collection.reloadData()
        print("collection cell 2: \(frame.height)")
    }
}

extension DynamicCollectionCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionStackCell", for: indexPath)
        cell.setNeedsUpdateConstraints()
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        print("collection cell load: \(cell.frame.height)")
        print("collection cell load: \(frame.height)")
        frame = cell.frame
        return cell
    }
    
}

extension DynamicCollectionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		//return UICollectionViewFlowLayoutAutomaticSize
        //return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        return CGSize(width: collectionView.frame.width, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0, bottom: 0.0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

class CollectionStackCell: UICollectionViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        print("collection stack cell: \(frame.height)")
    }
}
