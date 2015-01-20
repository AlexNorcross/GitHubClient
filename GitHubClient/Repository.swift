//
//  Repository.swift
//  GitHubClient
//
//  Created by Alexandra Norcross on 1/19/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import Foundation

struct Repository {
  let name: String
  let author: String!
  
  //Initialize: Parson JSON data.
  init(jsonRepository: [String : AnyObject]) {
    //Repositiory properties:
    self.name = jsonRepository["name"] as String
    
    //Owner properties:
    if let owner = jsonRepository["owner"] as? [String : AnyObject] {
      self.author = owner["login"] as String
    } //end if
  } //end init
}