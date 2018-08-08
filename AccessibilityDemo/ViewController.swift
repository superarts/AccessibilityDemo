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

	private let css = "@import url(https://fonts.googleapis.com/css?family=Unica+One);#55BF3B,#7798BF,#90ee7e,#DF5353,#aaeeee,#aaeeee; .highcharts-container,#eeaaee,#f45b5b,#ff0066,$colors: #2b908f{position:relative;overflow:hidden;width:100%;height:100%;text-align:left;line-height:normal;z-index:0;-webkit-tap-highlight-color:transparent;font-family:'Unica One',sans-serif;font-size:12px}.highcharts-root text{stroke-width:0}.highcharts-background{fill:#3e3e40}.highcharts-label-box,.highcharts-plot-background,.highcharts-plot-border{fill:none}.highcharts-subtitle,.highcharts-title{fill:#E0E0E3;text-transform:uppercase}.highcharts-title{font-size:20px}.highcharts-axis-line{fill:none;stroke:#C0D0E0}.highcharts-yaxis .highcharts-axis-line{stroke-width:0}.highcharts-axis-title{fill:#707070}.highcharts-axis-labels{fill:#E0E0E3;cursor:default;font-size:.9em}.highcharts-grid-line{fill:none;stroke:#D8D8D8}.highcharts-xaxis-grid .highcharts-grid-line{stroke-width:0}.highcharts-tick{stroke:#C0D0E0}.highcharts-yaxis .highcharts-tick{stroke-width:0}.highcharts-minor-grid-line{stroke:#e0e0e0}.highcharts-crosshair-thin{stroke-width:1px;stroke:silver}.highcharts-crosshair-category{stroke:rgba(155,200,255,.2)}.highcharts-credits{cursor:pointer;fill:#666;font-size:.7em;transition:fill 250ms,font-size 250ms}.highcharts-credits:hover{fill:#000;font-size:1em}.highcharts-tooltip{cursor:default;pointer-events:none;white-space:nowrap;transition:stroke 150ms;filter:url(#drop-shadow)}.highcharts-tooltip text{fill:#F0F0F0}.highcharts-tooltip .highcharts-header{font-size:.85em}.highcharts-tooltip-box{stroke-width:1px;fill:rgba(0,0,0,.85);fill-opacity:.85}.highcharts-selection-marker{fill:#4572A7;fill-opacity:.25}.highcharts-graph{fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}.highcharts-state-hover .highcharts-graph{stroke-width:3}.highcharts-state-hover path{transition:stroke-width 50}.highcharts-state-normal path{transition:stroke-width 250ms}.highcharts-point,g.highcharts-series{transition:opacity 250ms}.highcharts-legend-point-active .highcharts-point:not(.highcharts-point-hover),.highcharts-legend-series-active g.highcharts-series:not(.highcharts-series-hover){opacity:.2}@for $i from 1 through length($colors){{fill:$color;stroke:$color}}.highcharts-area{fill-opacity:.75;stroke-width:0}.highcharts-markers{stroke-width:1px;stroke:#fff}.highcharts-point{stroke-width:1px}.highcharts-legend .highcharts-point{stroke-width:0}.highcharts-data-label{font-size:.9em;font-weight:700}.highcharts-data-label-box{fill:none;stroke-width:0}.highcharts-data-label text{font-size:11px;font-weight:700;color:#B0B0B3;text-shadow:0 0 6px #000,0 0 3px #000;fill:#B0B0B3;text-rendering:geometricPrecision}.highcharts-data-label-connector{fill:none}.highcharts-halo{fill-opacity:.25;stroke-width:0}.highcharts-point-select{fill:#FFF;stroke:#000}.highcharts-column-series .highcharts-point{transition:fill-opacity 250ms}.highcharts-column-series .highcharts-point-hover{fill-opacity:.75;transition:fill-opacity 50ms}.highcharts-pie-series .highcharts-point{stroke-linejoin:round;stroke:#fff}.highcharts-pie-series .highcharts-point-hover{fill-opacity:.75;transition:fill-opacity 50ms}.highcharts-pie-series .highcharts-point-select{fill:inherit;stroke:inherit}.highcharts-funnel-series .highcharts-point{stroke-linejoin:round;stroke:#fff}.highcharts-funnel-series .highcharts-point-hover{fill-opacity:.75;transition:fill-opacity 50ms}.highcharts-funnel-series .highcharts-point-select{fill:inherit;stroke:inherit}.highcharts-pyramid-series .highcharts-point{stroke-linejoin:round;stroke:#fff}.highcharts-pyramid-series .highcharts-point-hover{fill-opacity:.75;transition:fill-opacity 50ms}.highcharts-pyramid-series .highcharts-point-select{fill:inherit;stroke:inherit}.highcharts-solidgauge-series .highcharts-point{stroke-width:0}.highcharts-treemap-series .highcharts-point{stroke-width:1px;stroke:#e0e0e0;transition:stroke 250ms,fill 250ms,fill-opacity 250ms}.highcharts-treemap-series .highcharts-point-hover{stroke:#000;transition:stroke 25ms,fill 25ms,fill-opacity 25ms}.highcharts-treemap-series .highcharts-above-level{display:none}.highcharts-treemap-series .highcharts-internal-node{fill:none}.highcharts-treemap-series .highcharts-internal-node-interactive{fill-opacity:.15;cursor:pointer}.highcharts-treemap-series .highcharts-internal-node-interactive:hover{fill-opacity:.75}.highcharts-legend-box{fill:none;stroke-width:0}.highcharts-legend-item text{fill:#E0E0E3;font-weight:700;cursor:pointer;stroke-width:0}.highcharts-legend-item:hover text{fill:#fff}.highcharts-legend-item-hidden *{fill:#ccc!important;stroke:#ccc!important;transition:fill 250ms}.highcharts-legend-nav-active{fill:#274b6d;cursor:pointer}.highcharts-legend-nav-inactive{fill:silver}.highcharts-legend-title-box{fill:none;stroke-width:0}.highcharts-loading{position:absolute;background-color:#fff;opacity:.5;text-align:center;z-index:10;transition:opacity 250ms}.highcharts-loading-hidden{height:0!important;opacity:0;overflow:hidden;transition:opacity 250ms,height 250ms step-end}.highcharts-loading-inner{font-weight:700;position:relative;top:45%}.highcharts-plot-band{fill:rgba(0,0,0,.05)}.highcharts-plot-line{fill:none;stroke:gray;stroke-width:1px}.highcharts-boxplot-box{fill:#fff}.highcharts-boxplot-median{stroke-width:2px}.highcharts-bubble-series .highcharts-point{fill-opacity:.5}.highcharts-errorbar-series .highcharts-point{stroke:#000}.highcharts-gauge-series .highcharts-data-label-box{stroke:silver;stroke-width:1px}.highcharts-gauge-series .highcharts-dial{fill:#000;stroke-width:0}.highcharts-polygon-series .highcharts-graph{fill:inherit;stroke-width:0}.highcharts-waterfall-series .highcharts-graph{stroke:#333;stroke-dasharray:1,3}.highcharts-navigator-mask{fill:rgba(128,179,236,.3)}.highcharts-navigator-mask-inside{fill:rgba(128,179,236,.3);cursor:ew-resize}.highcharts-navigator-outline{stroke:#b2b1b6;fill:none}.highcharts-navigator-handle{stroke:#b2b1b6;fill:#ebe7e8;cursor:ew-resize}.highcharts-navigator-series{fill:#4572A7;stroke:#4572A7}.highcharts-navigator-series .highcharts-graph{stroke-width:1px}.highcharts-navigator-series .highcharts-area{fill-opacity:.05}.highcharts-navigator-xaxis .highcharts-axis-line{stroke-width:0}.highcharts-navigator-xaxis .highcharts-grid-line{stroke-width:1px;stroke:#eee}.highcharts-navigator-xaxis.highcharts-axis-labels{fill:#888}.highcharts-navigator-yaxis .highcharts-grid-line{stroke-width:0}.highcharts-scrollbar-thumb{fill:#bfc8d1;stroke:#bbb;stroke-width:1px}.highcharts-scrollbar-button{fill:#ebe7e8;stroke:#bbb;stroke-width:1px}.highcharts-scrollbar-arrow{fill:#666}.highcharts-scrollbar-rifles{stroke:#666;stroke-width:1px}.highcharts-scrollbar-track{fill:#eee;stroke:#eee;stroke-width:1px}.highcharts-button{cursor:default;fill:#f6f6f6;stroke:#CCC;stroke-width:1px;transition:fill 250ms}.highcharts-button text{fill:#000}.highcharts-button-hover{fill:#acf;stroke:#68A;transition:fill 0s}.highcharts-button-pressed{fill:#cdf;stroke:#68A;font-weight:700}.highcharts-button-disabled text{fill:#ccc}.highcharts-range-selector-buttons .highcharts-button{stroke-width:0}.highcharts-range-label rect{fill:none}.highcharts-range-label text{fill:#666}.highcharts-range-input rect{fill:none}.highcharts-range-input text{fill:#444}input.highcharts-range-selector{position:absolute;border:0;width:1px;height:1px;padding:0;text-align:center;left:-9em}.highcharts-crosshair-label text{fill:#fff;font-size:1.1em}.highcharts-crosshair-label .highcharts-label-box{fill:inherit}.highcharts-candlestick-series .highcharts-point{stroke:#000;stroke-width:1px}.highcharts-candlestick-series .highcharts-point-up{fill:#fff}.highcharts-ohlc-series .highcharts-point-hover{stroke-width:3px}.highcharts-flags-series .highcharts-point{stroke:gray;fill:#fff}.highcharts-flags-series .highcharts-point-hover{stroke:#000;fill:#FCFFC5}.highcharts-flags-series .highcharts-point text{fill:#000;font-size:.9em;font-weight:700}.highcharts-map-series .highcharts-point{transition:fill .5s,fill-opacity .5s,stroke-width 250ms;stroke:silver}.highcharts-map-series .highcharts-point-hover{transition:fill 0s,fill-opacity 0s;fill-opacity:.5;stroke-width:2px}.highcharts-coloraxis,.highcharts-heatmap-series .highcharts-point{stroke-width:0}.highcharts-mapline-series .highcharts-point{fill:none}.highcharts-map-navigation{font-size:1.3em;font-weight:700;text-align:center}.highcharts-coloraxis-marker{fill:gray}.highcharts-null-point{fill:#f8f8f8}.highcharts-3d-frame{fill:transparent}.highcharts-column-series .highcharts-point{stroke:inherit}.highcharts-3d-top{filter:url(#highcharts-brighter)}.highcharts-3d-side{filter:url(#highcharts-darker)}.highcharts-contextbutton{fill:#fff;stroke:none;stroke-linecap:round}.highcharts-contextbutton:hover{fill:#acf;stroke:#acf}.highcharts-button-symbol{stroke:#666;stroke-width:3px;fill:#E0E0E0}.highcharts-menu{border:1px solid #A0A0A0;background:#FFF;padding:5px 0;box-shadow:3px 3px 10px #888}.highcharts-menu-item{padding:0 1em;background:0 0;color:#303030;cursor:pointer}.highcharts-menu-item:hover{background:#4572A5;color:#FFF}.highcharts-drilldown-point{cursor:pointer}.highcharts-drilldown-axis-label,.highcharts-drilldown-data-label text{cursor:pointer;fill:#0d233a;font-weight:700;text-decoration:underline}.highcharts-no-data text{font-weight:700;font-size:12px;fill:#60606a}"
}


    private let investmentOfferText: UITextView = {
        let textView = UITextView()
        
        textView.isScrollEnabled = false
        textView.backgroundColor = JPNewThemeManager.shared().createColor("noColor")
        textView.isEditable = false
        textView.isSelectable = true
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainerInset = UIEdgeInsets.zero;
        textView.textContainer.lineFragmentPadding = 0;
        
        let font = JPNewThemeManager.shared().createFont("Font2") ?? UIColor.white
        let white = JPNewThemeManager.shared().createColor("whiteColor") ?? UIFont.systemFont(ofSize: 12)
       
		let rawText = "Investment products and services are offered through J.P. Morgan Securities LLC (JPMS), a Member of FINRA and SIPC."
        if let rawText = "Investment products Offer".localized(),
            let sRange = rawText.range(of: InvestmentDisclosureTags.sipcTag.textValue()),
            let fRange = rawText.range(of: InvestmentDisclosureTags.finraTag.textValue()) {
            let attributedString = NSMutableAttributedString(string: rawText)
            
            attributedString.addAttribute(NSAttributedStringKey.link , value: InvestmentDisclosureTags.sipcTag.externalLink(), range: rawText.range(from: sRange))
            attributedString.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: rawText.range(from: sRange))
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor , value: white, range: rawText.range(from: sRange))
            
            attributedString.addAttribute(NSAttributedStringKey.link , value: InvestmentDisclosureTags.finraTag.externalLink(), range: rawText.range(from: fRange))
            attributedString.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: rawText.range(from: fRange))
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor , value: white, range: rawText.range(from: fRange))
            
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: white, range: rawText.range(from: rawText.startIndex..<rawText.endIndex))
            attributedString.addAttribute(NSAttributedStringKey.font, value: font, range: rawText.range(from: rawText.startIndex..<rawText.endIndex))
            
            textView.attributedText = attributedString
            textView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: white]
            
        } else {
            textView.font = JPNewThemeManager.shared().createFont("Font2")
            textView.textColor = JPNewThemeManager.shared().createColor("whiteColor")
            textView.text = "Investment products Offer".localized()
        }
        textView.sizeToFit()
        return textView
    }()
