//
//  WebViewController.swift
//  GitHubClient
//
//  Created by Alexandra Norcross on 1/22/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
  //Web broswer: to display url specified
  let webView = WKWebView()
  var url: String!
  
  //Function: Layout view controller.
  override func loadView() {
    //Root view:
    let rootView = UIView(frame: UIScreen.mainScreen().bounds)
    
    //Add objects.
    rootView.addSubview(webView)
    //Set layout.
    var dictionarySubview = [String : AnyObject]()
    webView.setTranslatesAutoresizingMaskIntoConstraints(false)
    dictionarySubview["webView"] = webView
    let webViewContraintsHoriz = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[webView]-0-|", options: nil, metrics: nil, views: dictionarySubview)
    rootView.addConstraints(webViewContraintsHoriz)
    let webViewContraintsVert = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[webView]-|", options: nil, metrics: nil, views: dictionarySubview)
    rootView.addConstraints(webViewContraintsVert)
    
    //Set view to root view.
    self.view = rootView
  } //end func
  
  //Function: Set up view controller.
  override func viewDidLoad() {
    //Super:
    super.viewDidLoad()

    //Set web view url.
    let request = NSURLRequest(URL: NSURL(string: url)!)
    webView.loadRequest(request)
  } //end func
}
