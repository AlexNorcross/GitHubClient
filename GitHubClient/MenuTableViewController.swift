//
//  MenuTableViewController.swift
//  GitHubClient
//
//  Created by Alexandra Norcross on 1/19/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
  //Table: containing menu options
  @IBOutlet var tableMenu: UITableView!
  //Alert: user that permissions are needed
  var alertPermission: PermissionAlertView!
  
  //Network controller:
  let networkController = NetworkController.sharedNetworkController
  
  //Function: Set up view controller.
  override func viewDidLoad() {
    //Super:
    super.viewDidLoad()
  } //end func
  
  //Function: Set up after View Controller appeared. Include retrieval of access token.
  override func viewDidAppear(animated: Bool) {
    //Super:
    super.viewDidAppear(animated)
    
    //Navigation controller:
    self.navigationController?.delegate = nil
    
    //Set up permissions alert view.
    alertPermission = NSBundle.mainBundle().loadNibNamed("PermissionAlertView", owner: self, options: nil).first as PermissionAlertView
    alertPermission.center = self.view.center
    alertPermission.alpha = 0
    alertPermission.transform = CGAffineTransformMakeScale(0.5, 0.5)
    self.view.addSubview(alertPermission)
    alertPermission.buttonOK.addTarget(self, action: "pressedAlertPermissionOK", forControlEvents: UIControlEvents.TouchUpInside)
    
    //Retrieve access token. If none, alert user that permissions must be granted.
    if networkController.accessToken == nil {
      UIView.animateWithDuration(1.0, animations: { () -> Void in
        self.alertPermission.alpha = 1.0
        self.alertPermission.transform = CGAffineTransformMakeScale(1.0, 1.0)
      }) //end closure
    } //end if
  } //end func

  //Function: Handle event when OK button on alert key entry view is pressed.
  func pressedAlertPermissionOK() {
    UIView.animateWithDuration(1.0, animations: { () -> Void in
      self.alertPermission.alpha = 0
    }) { (finished) -> Void in
      //Sign in: alert user - user will be sent to sign into service.
      self.networkController.requestTemporaryCode()
    } //end closure
  } //end func
}
