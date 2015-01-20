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

    //Retrieve access token. If none, request access token.
    if networkController.accessToken == nil {
      //Sign in: alert user - user will be sent to sign into service.
      networkController.requestTemporaryCode()
    } //end if
  } //end func
}
