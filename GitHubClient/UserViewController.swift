//
//  UserViewController.swift
//  GitHubClient
//
//  Created by Alexandra Norcross on 1/21/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
  //Image: to display user avatar
  @IBOutlet weak var imageUser: UIImageView!
  //Label: to display user name
  @IBOutlet weak var labelUserName: UILabel!
  
  //Selected user:
  var selectedUser: User!
  
  //Function: Set up view controller.
  override func viewDidLoad() {
    //Super:
    super.viewDidLoad()
    
    //Setup up.
    imageUser.image = selectedUser.avatarImage
    labelUserName.text = selectedUser.name
  } //end func
}
