//
//  BaseTableViewCell.swift
//  GoogleDrive
//
//  Created by Ankit on 20/04/19.
//  Copyright © 2019 Ankit. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
