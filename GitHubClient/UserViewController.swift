//
//  UserViewController.swift
//  GitHubClient
//
//  Created by Alexandra Norcross on 1/21/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  //Image: to display user avatar
  @IBOutlet weak var imageUser: UIImageView!
  //Label: to display user name
  @IBOutlet weak var labelUserName: UILabel!
  //Table: to display user repositories
  @IBOutlet weak var tableRepositories: UITableView!
  
  //Selected user:
  var selectedUser: User!
  //Network controller:
  let networkController = NetworkController.sharedNetworkController
  //Selected user repositories:
  var repositories = [Repository]()
  
  //Function: Set up view controller.
  override func viewDidLoad() {
    //Super:
    super.viewDidLoad()
    
    //User repositories:
    networkController.fetchRepositoriesByUser(selectedUser.name, callback: { (repositories, error) -> () in
      if error == nil {
        if repositories != nil {
          self.repositories = repositories!
          self.tableRepositories.reloadData()
        } //end if
      } //end if
    }) //end closure
    
    //Setup: display.
    imageUser.layer.cornerRadius = 20
    imageUser.layer.masksToBounds = true 
    //Setup up: contents.
    imageUser.image = selectedUser.avatarImage
    labelUserName.text = selectedUser.name
    
    //Table: register cell nib, etc.
    tableRepositories.registerNib(UINib(nibName: "RepositoryTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CELL_REPOSITORY")
    tableRepositories.dataSource = self
    tableRepositories.delegate = self
    //Set row height automatic.
    tableRepositories.estimatedRowHeight = 100
    tableRepositories.rowHeight = UITableViewAutomaticDimension
  } //end func
  
  //MARK: TableView Data Source
  
  //Function: Set table row count.
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return repositories.count
  } //end func

  //Function: Set table cell content.
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //Cell:
    let cell = tableView.dequeueReusableCellWithIdentifier("CELL_REPOSITORY", forIndexPath: indexPath) as RepositoryTableViewCell
    //Cell contents:
    let repo = repositories[indexPath.row]
    cell.labelRepositoryName.text = repo.name
    cell.labelAuthor.text = repo.author
    //Return cell.
    return cell
  } //end func

  //MARK: TableView Delegate
  
  //Function: Handle event when table view cell is selected.
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //Web view controller:
    let webVC = self.storyboard?.instantiateViewControllerWithIdentifier("VC_WEB") as WebViewController
    webVC.url = repositories[indexPath.row].url
    //Present view controller.
    navigationController?.pushViewController(webVC, animated: true)
    //Navigation controller:
    self.navigationController?.delegate = nil
  } //end func
}
