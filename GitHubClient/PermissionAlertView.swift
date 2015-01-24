//
//  PermissionAlertView.swift
//  GitHubClient
//
//  Created by Alexandra Norcross on 1/22/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import UIKit

class PermissionAlertView: UIView {
  //Objects:
  @IBOutlet weak var buttonOK: UIButton!
  
  //Function: Set up Nib.
  override func awakeFromNib() {
    //Super:
    super.awakeFromNib()
    
    //Set up.
    buttonOK.titleLabel?.font = UIFont(name: "Avenir-Black", size: 17.0)
  } //end func
}
