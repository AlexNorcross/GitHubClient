//
//  Extensions.swift
//  GitHubClient
//
//  Created by Alexandra Norcross on 1/22/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import Foundation

extension String {
  
  //Function: Check search term character.
  func validateSearchTerm() -> Bool {
    let regExp = NSRegularExpression(pattern: "[^0-9a-zA-Z\n\\-]", options: nil, error: nil)
    let range = NSMakeRange(0, countElements(self))

    if regExp!.numberOfMatchesInString(self, options: nil, range: range) == 0 {
      return true
    } else {
      return false
    } //end if
  } //end func
  
  //Function: Check user name character.
  func validateUserName() -> Bool {
    let regExp = NSRegularExpression(pattern: "[^0-9a-zA-Z\n\\-]", options: nil, error: nil)
    let range = NSMakeRange(0, countElements(self))
    
    if regExp?.numberOfMatchesInString(self, options: nil, range: range) == 0 {
      return true
    } else {
      return false
    } //end if
  } //end func
}