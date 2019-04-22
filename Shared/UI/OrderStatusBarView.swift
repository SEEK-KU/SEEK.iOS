//
//  OrderStatusBarView.swift
//  Shared
//
//  Created by oatThanut on 7/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity
import SnapKit
import UIKit

public class OrderStatusBarView: UIView
{
    
    public var orderStatus: Post.OrderStatusType = .confirmPrice {
        didSet { didsetOrderStatus(oldValue) } }
    
    // MARK: - Subviews
    
    private let orderConfirmButton = UIButton()
    private let orderConfirmLabel = UILabel()
    private let toBuyingLine = UIView()
    private let buyingButton = UIButton()
    private let buyingLabel = UILabel()
    private let toShippingView = UIView()
    private let shippingButton = UIButton()
    private let shippingLabel = UILabel()
    private let toCompletedView = UIView()
    private let completedButton = UIButton()
    private let completedLabel = UILabel()
    
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
        backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
        
        addSubview(toBuyingLine)
        addSubview(toShippingView)
        addSubview(toCompletedView)
        addSubview(orderConfirmButton)
        addSubview(buyingButton)
        addSubview(shippingButton)
        addSubview(completedButton)
        
        addSubview(orderConfirmLabel)
        addSubview(buyingLabel)
        addSubview(shippingLabel)
        addSubview(completedLabel)
        
        addViewConstraints()
        viewConfiguration()
    }
    
    private func viewConfiguration()
    {
        orderConfirmButton.setImage(#imageLiteral(resourceName: "icon-check-disable"), for: .normal)
        buyingButton.setImage(#imageLiteral(resourceName: "icon-check-disable"), for: .normal)
        shippingButton.setImage(#imageLiteral(resourceName: "icon-check-disable"), for: .normal)
        completedButton.setImage(#imageLiteral(resourceName: "icon-check-disable"), for: .normal)
        
        toShippingView.backgroundColor = #colorLiteral(red: 0.4638571739, green: 0.4639123082, blue: 0.4638254046, alpha: 1)
        toBuyingLine.backgroundColor = #colorLiteral(red: 0.4638571739, green: 0.4639123082, blue: 0.4638254046, alpha: 1)
        toCompletedView.backgroundColor  = #colorLiteral(red: 0.4638571739, green: 0.4639123082, blue: 0.4638254046, alpha: 1)
        
        orderConfirmLabel.text = "ยืนยันคำสั่งซื้อ"
        orderConfirmLabel.font = orderConfirmLabel.font.withSize(13.0)
        buyingLabel.text = "กำลังซื้อ"
        buyingLabel.font = buyingLabel.font.withSize(13.0)
        shippingLabel.text = "กำลังจัดส่ง"
        shippingLabel.font = shippingLabel.font.withSize(13.0)
        completedLabel.text = "ได้รับสินค้า"
        completedLabel.font = completedLabel.font.withSize(13.0)
    }
    
    // MARK: Constraints
    
    private func addViewConstraints()
    {
        orderConfirmButton
            .snp
            .makeConstraints {
                $0.leading.greaterThanOrEqualToSuperview()
                $0.size.equalTo(20.0)
                $0.centerY.equalTo(toShippingView.snp.centerY)
        }
        
        toBuyingLine
            .snp
            .makeConstraints {
                $0.leading.equalTo(orderConfirmButton.snp.centerX)
                $0.width.equalTo(UIScreen.main.bounds.width / 5.0)
                $0.height.equalTo(3.0)
                $0.centerY.equalTo(toShippingView.snp.centerY)
        }
        
        buyingButton
            .snp
            .makeConstraints {
                $0.centerX.equalTo(toShippingView.snp.leading)
                $0.size.equalTo(20.0)
                $0.centerY.equalTo(toShippingView.snp.centerY)
        }
        
        toShippingView
            .snp
            .makeConstraints {
                $0.leading.equalTo(toBuyingLine.snp.trailing)
                $0.top.equalToSuperview().offset(30.0)
                $0.bottom.equalToSuperview().offset(-48.0)
                $0.width.equalTo(UIScreen.main.bounds.width / 5.0)
                $0.height.equalTo(3.0)
                $0.centerX.equalToSuperview()
        }
        
        shippingButton
            .snp
            .makeConstraints {
                $0.centerX.equalTo(toCompletedView.snp.leading)
                $0.size.equalTo(20.0)
                $0.centerY.equalTo(toShippingView.snp.centerY)
        }
        
        toCompletedView
            .snp
            .makeConstraints {
                $0.leading.equalTo(toShippingView.snp.trailing)
                $0.width.equalTo(UIScreen.main.bounds.width / 5.0)
                $0.height.equalTo(3.0)
                $0.centerY.equalTo(toShippingView.snp.centerY)
        }
        
        completedButton
            .snp
            .makeConstraints {
                $0.trailing.lessThanOrEqualToSuperview()
                $0.size.equalTo(20.0)
                $0.centerX.equalTo(toCompletedView.snp.trailing)
                $0.centerY.equalTo(toShippingView.snp.centerY)
        }
        
        orderConfirmLabel
            .snp
            .makeConstraints {
                $0.top.equalTo(orderConfirmButton.snp.bottom).offset(8.0)
                $0.centerX.equalTo(orderConfirmButton.snp.centerX)
        }
        
        buyingLabel
            .snp
            .makeConstraints {
                $0.top.equalTo(buyingButton.snp.bottom).offset(8.0)
                $0.centerX.equalTo(buyingButton.snp.centerX)
        }
        
        shippingLabel
            .snp
            .makeConstraints {
                $0.top.equalTo(shippingButton.snp.bottom).offset(8.0)
                $0.centerX.equalTo(shippingButton.snp.centerX)
        }
        
        completedLabel
            .snp
            .makeConstraints {
                $0.top.equalTo(completedButton.snp.bottom).offset(8.0)
                $0.centerX.equalTo(completedButton.snp.centerX)
        }
        
        
    }
}

extension OrderStatusBarView
{
    func didsetOrderStatus(_ oldvalue: Post.OrderStatusType)
    {
        
        if orderStatus == .confirmPrice
        {
            orderConfirmButton.setImage(#imageLiteral(resourceName: "icon-check-disable"), for: .normal)
            buyingButton.setImage(#imageLiteral(resourceName: "icon-check-disable"), for: .normal)
            shippingButton.setImage(#imageLiteral(resourceName: "icon-check-disable"), for: .normal)
            completedButton.setImage(#imageLiteral(resourceName: "icon-check-disable"), for: .normal)
            toShippingView.backgroundColor = #colorLiteral(red: 0.4638571739, green: 0.4639123082, blue: 0.4638254046, alpha: 1)
            toBuyingLine.backgroundColor = #colorLiteral(red: 0.4638571739, green: 0.4639123082, blue: 0.4638254046, alpha: 1)
            toCompletedView.backgroundColor  = #colorLiteral(red: 0.4638571739, green: 0.4639123082, blue: 0.4638254046, alpha: 1)
        }
        else if orderStatus == .accepted
        {
            orderConfirmButton.setImage(#imageLiteral(resourceName: "icon-check"), for: .normal)
        }
        else if orderStatus == .processing
        {
            orderConfirmButton.setImage(#imageLiteral(resourceName: "icon-check"), for: .normal)
            buyingButton.setImage(#imageLiteral(resourceName: "icon-check"), for: .normal)
            
            toBuyingLine.backgroundColor = #colorLiteral(red: 0, green: 0.5294117647, blue: 1, alpha: 1)
        }
        else if orderStatus == .shipping
        {
            orderConfirmButton.setImage(#imageLiteral(resourceName: "icon-check"), for: .normal)
            buyingButton.setImage(#imageLiteral(resourceName: "icon-check"), for: .normal)
            shippingButton.setImage(#imageLiteral(resourceName: "icon-check"), for: .normal)
            
            toBuyingLine.backgroundColor = #colorLiteral(red: 0, green: 0.5294117647, blue: 1, alpha: 1)
            toShippingView.backgroundColor = #colorLiteral(red: 0, green: 0.5294117647, blue: 1, alpha: 1)
        }
        else if orderStatus == .completed
        {
            orderConfirmButton.setImage(#imageLiteral(resourceName: "icon-check"), for: .normal)
            buyingButton.setImage(#imageLiteral(resourceName: "icon-check"), for: .normal)
            shippingButton.setImage(#imageLiteral(resourceName: "icon-check"), for: .normal)
            completedButton.setImage(#imageLiteral(resourceName: "icon-check"), for: .normal)
            
            toBuyingLine.backgroundColor = #colorLiteral(red: 0, green: 0.5294117647, blue: 1, alpha: 1)
            toShippingView.backgroundColor = #colorLiteral(red: 0, green: 0.5294117647, blue: 1, alpha: 1)
            toCompletedView.backgroundColor = #colorLiteral(red: 0, green: 0.5294117647, blue: 1, alpha: 1)
        }
        else
        {
            //
        }
    }
}
