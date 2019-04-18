//
//  GrandTotalView.swift
//  Shared
//
//  Created by oatThanut on 6/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

public class GrandTotalView: UIView
{
    public var buttonTitle: String {
        get { return nextButton.titleLabel?.text ?? "" }
        set { nextButton.setTitle(newValue, for: .normal) } }
    
    public var price: String {
        get { return priceLabel.text ?? "" }
        set { priceLabel.text = "\(newValue) ฿" } }
    
    // MARK: - SubView
    
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    fileprivate let nextButton = UIButton()
    
    // MARK: - Initializer
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        commoninit()
    }
    
    public required init?(
        coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        commoninit()
    }
    
    private func commoninit()
    {
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(nextButton)
        
        viewConfiguration()
        addViewConstraints()
    }
    
    private func viewConfiguration()
    {
        titleLabel.text = "ราคาสุทธิ"
        titleLabel.textAlignment = .left
        
        priceLabel.textAlignment = .right
        
        nextButton.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.5176470588, blue: 0.2666666667, alpha: 1)
        nextButton.setTitle("ยืนยันคำสั่งซื้อ", for: .normal)
        nextButton.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        nextButton.layer.cornerRadius = 8
    }
    
    // MARK: Constraints
    
    private func addViewConstraints()
    {
        titleLabel
            .snp
            .makeConstraints {
                $0
                    .leading
                    .equalToSuperview()
                    .offset(24.0)
                $0
                    .top
                    .equalToSuperview()
                    .offset(24.0) }
        
        priceLabel
            .snp
            .makeConstraints {
                $0
                    .leading
                    .equalTo(titleLabel.snp.trailing)
                    .offset(16.0)
                $0
                    .trailing
                    .equalToSuperview()
                    .offset(-24.0)
                $0
                    .top
                    .equalToSuperview()
                    .offset(24.0)
                $0
                    .width
                    .equalTo(titleLabel.snp.width) }
        
        nextButton
            .snp
            .makeConstraints {
                $0
                    .leading
                    .equalToSuperview()
                    .offset(24.0)
                $0
                    .trailing
                    .equalToSuperview()
                    .offset(-24.0)
                $0
                    .top
                    .equalTo(titleLabel.snp.bottom)
                    .offset(16.0)
                $0
                    .bottom
                    .equalToSuperview()
                    .offset(-24.0)
                $0
                    .height
                    .equalTo(50) }
    }
}

extension Reactive where Base: GrandTotalView
{
    public var tap: ControlEvent<Void> { return base.nextButton.rx.tap }
}
