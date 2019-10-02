//
//  ListTableViewCell.swift
//  GoogleDrive
//
//  Created by Ankit on 20/04/19.
//  Copyright © 2019 Ankit. All rights reserved.
//

import UIKit

class ListTableViewCell: BaseTableViewCell {
    static let height: CGFloat =  160.0
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var file : FileDataModel? {
        didSet {
            guard let objFile = file else {
                return
            }
            lblFileName.text = objFile.fileName
            imgIcon.loadImageUsingCache(objFile.iconLink)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
