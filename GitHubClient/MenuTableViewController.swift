//
//  MenuTableViewController.swift
//  GitHubClient
//
//  Created by Alexandra Norcross on 1/19/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
  //Network controller:
  let networkController = NetworkController.sharedNetworkController
  
  //Function: Set up View Controller.
  override func viewDidLoad() {
    //Super:
    super.viewDidLoad()
  } //end func
  
  //Function: Set up after View Controller appeared. Include retrieval of access token.
  override func viewDidAppear(animated: Bool) {
    //Super:
    super.viewDidAppear(animated)
    
    //Retrieve access token. If none, alert user that permissions must be granted and request access token.
    if networkController.accessToken == nil {
      //Alert controller: to explain to user that permissions must be granted.
      let alertLogin = UIAlertController(title: "GitHubClient", message: "GitHubClient needs permission(s) to access your GitHub account.", preferredStyle: UIAlertControllerStyle.Alert)
      //OK button:
      let buttonOK = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
        //Sign in: alert user - user will be sent to sign into service.
        self.networkController.requestTemporaryCode()
      } //end closure
      alertLogin.addAction(buttonOK)
      //Present alert controller.
      self.presentViewController(alertLogin, animated: true, completion: nil)
    } //end if
  } //end func
}
