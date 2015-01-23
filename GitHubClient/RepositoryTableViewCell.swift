//
//  RepositoryTableViewCell.swift
//  GitHubClient
//
//  Created by Alexandra Norcross on 1/19/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
  //Label: to display repository name, author
  @IBOutlet weak var labelRepositoryName: UILabel!
  @IBOutlet weak var labelWrittenBy: UILabel!
  @IBOutlet weak var labelAuthor: UILabel!
  
  //Function: Set up Nib.
  override func awakeFromNib() {
    //Super:
    super.awakeFromNib()
    
    //Set up.
    self.labelWrittenBy.font = UIFont(name: "Avenir", size: 12.0)
    self.labelAuthor.font = UIFont(name: "Avenir", size: 12.0)
  } //end func

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
