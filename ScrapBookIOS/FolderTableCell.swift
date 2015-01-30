//
//  FolderTableCell.swift
//  ScrapBookIOS
//
//  Created by Clinic on 15-1-30.
//  Copyright (c) 2015年 Kiny. All rights reserved.
//

import UIKit

class FolderTableCell: UITableViewCell {
    var imgView:UIImageView!
    var label:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imgView = UIImageView(frame: CGRect(x: 10, y: 10, width: 32, height: 32))
        self.addSubview(imgView)
        
        label = UILabel()
        label.numberOfLines = 0
        self.addSubview(label)
    }
    
    var textString:String!{
        didSet{
            label.text = textString
            label.frame = CGRect(x: imgView.frame.width + 10, y: 0, width: self.frame.width - imgView.frame.width - 10, height: 100)
            label.sizeToFit()
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
