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
  @IBOutlet weak var labelAuthor: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
