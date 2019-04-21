//
//  TitleWithDisclosureView.swift
//  Shared
//
//  Created by oatThanut on 12/3/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

public class TitleWithDisclosureView: UIView
{
    
    public var title: String {
        get { return titleLabel.text ?? "" }
        set { titleLabel.text = newValue } }
    
    public var image: UIImage {
        get { return iconImageView.image ?? UIImage() }
        set { iconImageView.image = newValue } }
    
    // MARK: - Subviews
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let discloserImageView = UIImageView()
    fileprivate let contentButton = UIButton()
    
    public convenience init(
        title: String = "",
        icon: UIImage = UIImage(),
        shouldShowDisclosureIcon: Bool = true)
    {
        self.init(frame: .zero)
        
        self.title = title
        self.iconImageView.image = icon
        self.discloserImageView.isHidden = !shouldShowDisclosureIcon
    }
    
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
        backgroundColor = UIColor.white
        
        layer.borderWidth = 1
        layer.borderColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1).cgColor
        
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(discloserImageView)
        addSubview(contentButton)
        
        discloserImageView.image = #imageLiteral(resourceName: "icon-arrow-right")
        discloserImageView.contentMode = .scaleAspectFit
        
        addViewConstraints()
    }
    
    // MARK: Constraints
    
    private func addViewConstraints()
    {
        contentButton
            .snp
            .makeConstraints {
                $0
                    .edges
                    .equalToSuperview() }
        
        iconImageView
            .snp
            .makeConstraints {
                $0
                    .leading
                    .equalToSuperview()
                    .offset(60.0)
                $0
                    .centerY
                    .equalToSuperview()
                $0
                    .size
                    .equalTo(24.0) }
        
        titleLabel
            .snp
            .makeConstraints {
                $0
                    .top
                    .equalToSuperview()
                    .offset(16.0)
                $0
                    .bottom
                    .equalToSuperview()
                    .offset(-16.0)
                $0
                    .leading
                    .equalTo(iconImageView.snp.trailing)
                    .offset(16.0)
                $0
                    .trailing
                    .lessThanOrEqualTo(discloserImageView.snp.leading)
                $0
                    .height
                    .equalTo(24)
                $0
                    .centerY
                    .equalToSuperview() }
        
        discloserImageView
            .snp
            .makeConstraints {
                $0
                    .trailing
                    .equalToSuperview()
                    .offset(-60.0)
                $0
                    .centerY
                    .equalToSuperview()
                $0
                    .size
                    .equalTo(12.0) }
    }
}

extension Reactive where Base: TitleWithDisclosureView
{
    public var tap: ControlEvent<Void> { return base.contentButton.rx.tap }
}
