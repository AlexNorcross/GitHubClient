//
//  NetworkController.swift
//  GitHubClient
//
//  Created by Alexandra Norcross on 1/19/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import Foundation

class NetworkController {
  
  //Function: Fetch repositories from GitHub containing specified search term.
  //Input: term to search for, closure with json repository data and error
  func fetchRepositoryBySearchTerm(searchTerm: String, callback: ([Repository]?, String?) -> ()) {
    //URL session:
    let urlSessionConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    let urlSession = NSURLSession(configuration: urlSessionConfig)
    //let urlSearch = NSURL(string: "https://api.github.com/search/repositories?q=\(searchTerm)")
    let urlSearch = NSURL(string: "http://127.0.0.1:3000")!
    
    //Execute request and retrieve repositories.
    let dataTask = urlSession.dataTaskWithURL(urlSearch, completionHandler: { (jsonData, urlResponse, error) -> Void in
      if error == nil {
        let response = urlResponse as NSHTTPURLResponse
        switch response.statusCode {
          case 200...299:
            //Parse JSON response.
            if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: nil) as? [String : AnyObject] {
              //Repositories:
              var repositories = [Repository]()
              if let items = jsonDictionary["items"] as? [[String : AnyObject]] {
                for item in items {
                  repositories.append(Repository(jsonRepository: item))
                } //end for
              } //end if

              //Return to main queue.
              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                callback(repositories, nil)
              }) //end closure
            } //end if
          default:
            callback(nil, "Error retrieving repository by search term")
        } //end switcch
      } //end if
    }) //end closure
    dataTask.resume()
  } //end func
}