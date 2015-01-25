//
//  SearchUserViewController.swift
//  GitHubClient
//
//  Created by Alexandra Norcross on 1/21/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import UIKit

class SearchUserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UINavigationControllerDelegate {
  //Collection view: to display user images
  @IBOutlet weak var collectionUsers: UICollectionView!
  //Search bar:
  @IBOutlet weak var searchBar: UISearchBar!
  
  //Network controller:
  let networkController = NetworkController.sharedNetworkController
  //Users:
  var users = [User]()
  
  //Key entry alert view:
  var alertKeyEntry: KeyEntryAlertView!
  
  //Function: Set up view controller.
  override func viewDidLoad() {
    //Super:
    super.viewDidLoad()
    
    //Title:
    self.title = "Search Users"
    
    //Collection view: delegate & data source
    collectionUsers.delegate = self
    collectionUsers.dataSource = self
    
    //Search bar: delegate
    searchBar.delegate = self
  } //end func
  
  //Function: Set up view controller.
  override func viewWillAppear(animated: Bool) {
    //Navigation bar: delegate
    navigationController?.delegate = self
  } //end func

  //Function: Set up after View Controller appeared.
  override func viewDidAppear(animated: Bool) {
    //Super:
    super.viewDidAppear(animated)
    
    //Set up key entry alert view.
    alertKeyEntry = NSBundle.mainBundle().loadNibNamed("KeyEntryAlertView", owner: self, options: nil).first as KeyEntryAlertView
    alertKeyEntry.layer.cornerRadius = 10
    alertKeyEntry.center = self.view.center
    initAlertKeyEntry()
    self.view.addSubview(alertKeyEntry)
    alertKeyEntry.buttonOK.addTarget(self, action: "pressedAlertKeyEntryOK", forControlEvents: UIControlEvents.TouchUpInside)
  } //end func
  
  //MARK: CollectionView Data Source
  
  //Function: Set collection view cell count.
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return users.count
  } //end func
  
  //Function: Set collection view cell content.
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    //Cell:
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CELL_USER", forIndexPath: indexPath) as UserCollectionViewCell
    //User:
    var user = users[indexPath.row]
    //Cell contents:
    cell.imageUser.layer.cornerRadius = 10
    cell.imageUser.layer.masksToBounds = true
    cell.imageUser.image = nil
    cell.imageUser.alpha = 0 //set to fade in
    let cellAnimationDuration = 0.5
    if user.avatarImage == nil {
      networkController.fetchUserAvatarImage(user.avatarURL, callback: { (avatarImage) -> () in
        user.avatarImage = avatarImage
        self.users[indexPath.row].avatarImage = avatarImage
        cell.imageUser.image = user.avatarImage
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          UIView.animateWithDuration(cellAnimationDuration, animations: { () -> Void in
            cell.imageUser.alpha = 1.0
          }) //end closure
        }) //end closure
      }) //end closure
    } else {
      cell.imageUser.image = user.avatarImage
      UIView.animateWithDuration(cellAnimationDuration, animations: { () -> Void in
        cell.imageUser.alpha = 1.0
      }) //end closure
    } //end if
    //Return cell.
    return cell
  } //end func
  
  //MARK: SearchBar Delegate
  
  //Function: Validate text entered.
  func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    let validChar = text.validateUserName()
    if validChar == false {
      UIView.animateWithDuration(1.0, animations: { () -> Void in
        self.alertKeyEntry.alpha = 1
        self.alertKeyEntry.transform = CGAffineTransformMakeScale(1.0, 1.0)
      }) //end closure
    } //end if
    return validChar
  } //end func
  
  //Function: Handle event when Search button is selected.
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    //Search users.
    networkController.fetchUserBySearchTerm(searchBar.text, callback: { (users, error) -> () in
      if users != nil {
        self.users = users!
      } //end if
      self.collectionUsers.reloadData()
    }) //end closure
    //Dismiss keyboard.
    searchBar.resignFirstResponder()
  } //end func
  
  //MARK: Segue
  
  //Function: Segue to user view controller.
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "SEGUE_USER" {
      let userVC = segue.destinationViewController as UserViewController
      let indexPath = collectionUsers.indexPathsForSelectedItems().first as NSIndexPath
      userVC.selectedUser = users[indexPath.row]
    } //end if
  } //end func
  
  //MARK: NavigationBar Delegate
  
  //Function: Navigate with animation to user view controller.
  func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if toVC is UserViewController {
      return ToUserViewController()
    } else {
      return nil
    } //end if
  } //end func

  //MARK: Selectors
  
  //Function: Handle event when OK button on alert key entry view is pressed.
  func pressedAlertKeyEntryOK() {
    UIView.animateWithDuration(1.0, animations: { () -> Void in
      self.initAlertKeyEntry()
    }) //end func
  } //end func
  
  //MARK: Alert View
  
  //Function: Initialize alert key entry view.
  func initAlertKeyEntry() {
    alertKeyEntry.alpha = 0
    alertKeyEntry.transform = CGAffineTransformMakeScale(0.5, 0.5)
  } //end func
}
