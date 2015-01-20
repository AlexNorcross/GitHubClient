//
//  NetworkController.swift
//  GitHubClient
//
//  Created by Alexandra Norcross on 1/19/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import UIKit

class NetworkController {
  //Singleton: be able to access Network Controller throughout app
  class var sharedNetworkController: NetworkController { //class => resides in scope of class (not instance)
    struct Static {
      static let instance: NetworkController = NetworkController() //static => resides in scope of struct
    } //end struct
    return Static.instance
  } //end class var
  
  //Access token:
  var accessToken: String?
  let accessTokenUserDefaultsKey = "accessToken"
  
  //Client id & secret:
  let clientId = "0cd010995696f6929cd9"
  let clientSecret = "27c7b06d51096ce7c3ed89e1584f4dbda722c84f"
  
  //URL session:
  var urlSession: NSURLSession!
  
  //Initialize: Initialize URL session and retrieve access token, if any.
  init() {
    //URL session:
    urlSession = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
    //Access token:
    if let accessToken = NSUserDefaults.standardUserDefaults().objectForKey(accessTokenUserDefaultsKey) as? String {
      self.accessToken = accessToken
    } //end if
  } //end init
  
  //Function: Retieve temporary code from GitHub.
  func requestTemporaryCode() {
    let urlRequest = "https://github.com/login/oauth/authorize?client_id=\(clientId)&scope=user,repo"
    UIApplication.sharedApplication().openURL(NSURL(string: urlRequest)!)
  } //end func
  
  //Function: Handle callback from application opening app.
  func handleCallbackURL(url: NSURL) {
    //Temporary code:
    let tempCode = url.query

    //Retrieve access token.
      //URL:
      let urlOAuth = NSURL(string: "https://github.com/login/oauth/access_token?client_id=\(clientId)&client_secret=\(clientSecret)&\(tempCode!)")
      let urlRequest = NSMutableURLRequest(URL: urlOAuth!)
      urlRequest.HTTPMethod = "POST"
    
      //Execute request and retrieve access token.
      let dataTask = urlSession.dataTaskWithRequest(urlRequest, completionHandler: { (data, urlResponse, error) -> Void in
        if error == nil {
          let response = urlResponse as NSHTTPURLResponse
          switch response.statusCode {
            case 200...299:
              //Retrieve access token.
              let dataString = NSString(data: data, encoding: NSASCIIStringEncoding) //data to string
              let accessTokenUnit = dataString?.componentsSeparatedByString("&").first as String
              self.accessToken = accessTokenUnit.componentsSeparatedByString("=").last
              
              //Save access token.
              NSUserDefaults.standardUserDefaults().setObject(self.accessToken!, forKey: self.accessTokenUserDefaultsKey)
              NSUserDefaults.standardUserDefaults().synchronize()
            default:
              println("Error retrieving access token")
          } //end switch
        } //end if
      }) //end closure
      dataTask.resume()
  } //end func
  
  //Function: Fetch repositories from GitHub containing specified search term.
  //Input: term to search for, closure with json repository data and error
  func fetchRepositoryBySearchTerm(searchTerm: String, callback: ([Repository]?, String?) -> ()) {
    //URL: with authorization
    let urlRequest = NSMutableURLRequest(URL: NSURL(string: "https://api.github.com/search/repositories?q=\(searchTerm)")!)
    urlRequest.setValue("token \(accessToken!)", forHTTPHeaderField: "Authorization")
    
    //Execute request and retrieve repositories.
    let dataTask = urlSession.dataTaskWithRequest(urlRequest, completionHandler: { (jsonData, urlResponse, error) -> Void in
      if error == nil {
        let response = urlResponse as NSHTTPURLResponse
        println(response)
        switch response.statusCode {
          case 200...299:
            //Parse JSON response.
            var errorPointer: NSError?
            if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &errorPointer) as? [String : AnyObject] {
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