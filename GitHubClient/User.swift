//
//  User.swift
//  GitHubClient
//
//  Created by Alexandra Norcross on 1/21/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import UIKit

struct User {
  let name: String
  let avatarURL: String
  var avatarImage: UIImage?
  
  //Initialize: Parse JSON data.
  init(jsonUser: [String : AnyObject]) {
    self.name = jsonUser["login"] as String
    self.avatarURL = jsonUser["avatar_url"] as String
  } //end init
}