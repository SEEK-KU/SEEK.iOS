//
//  ItemListView.swift
//  Shared
//
//  Created by oatThanut on 3/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import RxSwift
import RxCocoa
import SnapKit
import UIKit

open class ItemListView: UIView
{
    var title: String {
        get { return titleLabel.text ?? "" }
        set { titleLabel.text = newValue } }
    
    public var itemName: String? {
        get { return itemNameTextField.text ?? "" }
        set { itemNameTextField.text = newValue } }
    
    public var itemPrice: String? {
        get { return itemPriceTextField.text ?? "" }
        set { itemPriceTextField.text = newValue } }
    
    public var itemQuantity: String? {
        get { return itemQuantityTextField.text ?? "" }
        set { itemQuantityTextField.text = newValue } }
    
    public var isAbleToEditPrice: Bool = false {
        didSet { didSetEditState(oldValue) } }
    
    public var isCreatingMode: Bool = false {
        didSet { didSetEditState(oldValue) } }
    
    fileprivate let isEndEditingPublishSubject = PublishSubject<String?>()
    
    // MARK: - Subviews
    private let titleLabel = UILabel()
    private let itemNameLabel = UILabel()
    private let itemNameTextField = UITextField()
    private let itemPriceLabel = UILabel()
    private let itemPriceTextField = UITextField()
    private let itemQuantityLabel = UILabel()
    private let itemQuantityTextField = UITextField()
    
    public convenience init(
        title: String = "",
        isCreatingMode: Bool = false)
    {
        self.init(frame: .zero)
        
        self.title = title
        self.isCreatingMode = isCreatingMode
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
    
    deinit
    {
        isEndEditingPublishSubject.onCompleted()
    }
    
    private func commoninit()
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(itemNameLabel)
        addSubview(itemNameTextField)
        addSubview(itemPriceLabel)
        addSubview(itemPriceTextField)
        addSubview(itemQuantityLabel)
        addSubview(itemQuantityTextField)
        
        itemPriceTextField.delegate = self
        
        viewConfiguration()
        addViewConstraints()
    }
    
    private func viewConfiguration()
    {
        isAbleToEditPrice = false
        
        itemNameLabel.text = "ชื่อ"
        itemNameLabel.setContentHuggingPriority(.required, for: .horizontal)
        itemNameTextField.borderStyle = .roundedRect
        itemNameTextField.placeholder = "ชื่ออาหาร/สิ่งของ&รายละเอียด"
        itemNameTextField.isEnabled = false
        
        itemPriceLabel.text = "ราคา"
        itemPriceLabel.setContentHuggingPriority(.required, for: .horizontal)
        itemPriceTextField.borderStyle = .roundedRect
        itemPriceTextField.placeholder = "บาท"
        
        itemQuantityLabel.text = "จำนวน"
        itemQuantityTextField.borderStyle = .roundedRect
        itemQuantityTextField.placeholder = "ชิ้น"
        itemQuantityTextField.isEnabled = false
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
                $0
                    .trailing
                    .equalToSuperview()
                $0
                    .top
                    .equalToSuperview()
                    .offset(8.0) }

        itemNameLabel
            .snp
            .makeConstraints {
                $0
                    .leading
                    .equalToSuperview()
                    .offset(48.0)
                $0
                    .top
                    .equalTo(titleLabel.snp.bottom)
                    .offset(8.0)
                $0
                    .width
                    .equalTo(24)
                $0
                    .centerY
                    .equalTo(itemNameTextField.snp.centerY) }
        
        itemNameTextField
            .snp
            .makeConstraints {
                $0
                    .leading
                    .equalTo(itemNameLabel.snp.trailing)
                    .offset(8.0)
                $0
                    .trailing
                    .equalToSuperview()
                $0
                    .top
                    .equalTo(titleLabel.snp.bottom)
                    .offset(8.0) }
        
        itemPriceLabel
            .snp
            .makeConstraints {
                $0
                    .trailing
                    .equalTo(itemPriceTextField.snp.leading)
                    .offset(-8.0)
                $0
                    .centerY
                    .equalTo(itemPriceTextField.snp.centerY) }

        itemPriceTextField
            .snp
            .makeConstraints {
                $0
                    .leading
                    .equalTo(itemNameTextField.snp.leading)
                $0
                    .top
                    .equalTo(itemNameTextField.snp.bottom)
                    .offset(8.0)
                $0
                    .bottom
                    .equalToSuperview()
                    .offset(-16.0) }

        itemQuantityLabel
            .snp
            .makeConstraints {
                $0
                    .leading
                    .equalTo(itemPriceTextField.snp.trailing)
                    .offset(8.0)
                $0
                    .trailing
                    .equalTo(itemQuantityTextField.snp.leading)
                    .offset(-8.0)
                $0
                    .width
                    .equalTo(50)
                $0
                    .centerY
                    .equalTo(itemQuantityTextField.snp.centerY) }

        itemQuantityTextField
            .snp
            .makeConstraints {
                $0
                    .trailing
                    .equalTo(itemNameTextField.snp.trailing)
                $0
                    .top
                    .equalTo(itemNameTextField.snp.bottom)
                    .offset(8.0)
                $0
                    .bottom
                    .equalToSuperview()
                    .offset(-16.0)
                $0
                    .width
                    .equalTo(50) }
    }
    
    private func didSetEditState(_ oldValue: Bool)
    {
        if isAbleToEditPrice == false
        {
            itemPriceTextField.isEnabled = false
        }
        else
        {
            itemPriceTextField.isEnabled = true
        }
        
        if isCreatingMode
        {
            itemNameTextField.isEnabled = true
            itemPriceTextField.isEnabled = true
            itemQuantityTextField.isEnabled = true
        }
    }
}

extension ItemListView: UITextFieldDelegate
{
    public func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == itemPriceTextField
        {
            isEndEditingPublishSubject.onNext(itemPriceTextField.text)
        }
    }
}

extension Reactive where Base: ItemListView
{
    public var didPriceChanged: PublishSubject<String?> { return base.isEndEditingPublishSubject }
}
