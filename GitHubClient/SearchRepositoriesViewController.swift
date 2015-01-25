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
  
  //Key entry alert view:
  var alertKeyEntry: KeyEntryAlertView!
  
  //Function: Set up view controller.
  override func viewDidLoad() {
    //Super:
    super.viewDidLoad()
    
    //Title:
    self.title = "Search Repositories"
    
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
    let validChar = text.validateSearchTerm()
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
