//
//  OrderListView.swift
//  SEEK
//
//  Created by oatThanut on 29/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import SnapKit
import UIKit

public class OrderListView: UIView
{
    var title: String {
        get { return titleLabel.text ?? "" }
        set { titleLabel.text = newValue } }
    
    var price: String {
        get { return priceTextField.text ?? "" }
        set { priceTextField.text = newValue } }
    
    private let titleLabel = UILabel()
    private let priceTextField = UITextField()
    
    // MARK: - Initializer
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    func commonInit()
    {
        backgroundColor = .white
        
        self.addSubview(titleLabel)
        self.addSubview(priceTextField)
        
        addViewConstraints()
    }
    
    // MARK: - Add View's Constraints
    
    private func addViewConstraints()
    {
        titleLabel
            .snp
            .makeConstraints {
                $0
                    .leading
                    .equalToSuperview()
                $0
                    .trailing
                    .equalTo(priceTextField.snp.leading)
                $0
                    .top
                    .equalToSuperview()
                $0
                    .bottom
                    .equalToSuperview()
                    .offset(16.0) }
        
        priceTextField
            .snp
            .makeConstraints {
                $0
                    .trailing
                    .equalToSuperview()
                $0
                    .top
                    .equalToSuperview()
                $0
                    .bottom
                    .equalToSuperview()
                    .offset(16.0)
                $0
                    .width
                    .equalTo(60.0) }
    }
}
