//
//  PostCollectionViewCell.swift
//  SEEK
//
//  Created by oatThanut on 21/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell
{
    
    var title: String {
        get { return TitleLabel.text ?? "" }
        set { TitleLabel.text = newValue } }
    
    @IBOutlet weak var TitleLabel: UILabel!
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    func commonInit()
    {
        backgroundColor = UIColor.white
        
        self.layer.cornerRadius = 10
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
        TitleLabel.text = ""
    }
}
