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
    
    var location: String {
        get { return locationLabel.text ?? "" }
        set { locationLabel.text = newValue } }
    
    var destination: String {
        get { return destinationLabel.text ?? "" }
        set { destinationLabel.text = newValue } }
    
    var tip: String {
        get { return tipLabel.text ?? "" }
        set { tipLabel.text = newValue } }
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    func commonInit()
    {
        backgroundColor = UIColor.white
        
        self.layer.cornerRadius = 8
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.clipsToBounds = false
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
        TitleLabel.text = ""
        locationLabel.text = ""
        destinationLabel.text = ""
    }
}
