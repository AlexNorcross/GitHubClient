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
  
  //Function: Set up view controller.
  override func viewDidLoad() {
    //Super:
    super.viewDidLoad()
    
    //Collection view: delegate & data source
    collectionUsers.delegate = self
    collectionUsers.dataSource = self
    
    //Search bar: delegate
    searchBar.delegate = self
    
    //Navigation bar: delegate
    navigationController?.delegate = self
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
    cell.imageUser.image = nil
    if user.avatarImage == nil {
      networkController.fetchUserAvatarImage(user.avatarURL, callback: { (avatarImage) -> () in
        user.avatarImage = avatarImage
        self.users[indexPath.row].avatarImage = avatarImage
        cell.imageUser.image = user.avatarImage
      }) //end closure
    } else {
      cell.imageUser.image = user.avatarImage
    } //end if
    //Return cell.
    return cell
  } //end func
  
  //MARK: SearchBar Delegate
  
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
    if fromVC is SearchUserViewController {
      return ToUserViewController()
    } else {
      return nil
    } //end if
  } //end func
}
