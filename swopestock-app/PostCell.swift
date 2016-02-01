//
//  PostCell.swift
//  swopestock-app
//
//  Created by Chad Comstock on 2/1/16.
//  Copyright © 2016 Chad Comstock. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func drawRect(rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
