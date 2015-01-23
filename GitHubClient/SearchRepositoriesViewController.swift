//
//  SearchRepositoriesViewController.swift
//  GitHubClient
//
//  Created by Alexandra Norcross on 1/19/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import UIKit

class SearchRepositoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
  //Table: to display repositories
  @IBOutlet weak var tableRepositories: UITableView!
  //Search bar:
  @IBOutlet weak var searchBar: UISearchBar!
  
  //Network controller:
  let networkController = NetworkController.sharedNetworkController
  //Repositories:
  var repositories = [Repository]()
  
  //Function: Set up view controller.
  override func viewDidLoad() {
    //Super:
    super.viewDidLoad()
    
    //Table: register cell nib, etc,
    tableRepositories.registerNib(UINib(nibName: "RepositoryTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CELL_REPOSITORY")
    tableRepositories.dataSource = self
    tableRepositories.delegate = self
    //Table: automatically adjust row height
    tableRepositories.estimatedRowHeight = 100
    tableRepositories.rowHeight = UITableViewAutomaticDimension
    
    //Search bar: delegate
    searchBar.delegate = self
  } //end func
  
  //MARK: TableView Data Source
  
  //Function: Set table view row count.
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return repositories.count
  } //end func
  
  //Function: Set table view cell contents.
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
  } //end func
  
  //MARK: SearchBar Delegate
  
  //Function: Validate text entered.
  func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    return text.validateSearchTerm()
  } //end func
  
  //Function: Handle event when Search button is selected.
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    //Search repositories.
    networkController.fetchRepositoryBySearchTerm(searchBar.text, callback: { (repositories, error) -> () in
      if repositories != nil {
        self.repositories = repositories!
      } //end if
      self.tableRepositories.reloadData()
    }) //end closure
    //Dismiss keyboard.
    searchBar.resignFirstResponder()
  } //end func
}
