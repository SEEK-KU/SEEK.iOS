//
//  ItemCheckView.swift
//  Shared
//
//  Created by oatThanut on 11/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import RxSwift
import RxCocoa
import SnapKit
import UIKit

public class ItemCheckView: UIView
{
    public var itemName: String? {
        get { return titleTextField.text ?? "" }
        set { titleTextField.text = newValue } }
    
    public var itemPrice: String? {
        get { return priceTextField.text ?? "" }
        set { priceTextField.text = newValue } }
    
    public var itemQuantity: String? {
        get { return quantityTextField.text ?? "" }
        set { quantityTextField.text = newValue } }
    
    public var isSelected: Bool {
        get { return checkButton.isSelected }
        set { checkButton.isSelected = newValue }
    }
    
    public var isAllowEditing: Bool = false {
        didSet { didSetViewState(oldValue) }
    }
    
    fileprivate let checkButton = UIButton()
    private let titleTextField = UITextField()
    private let quantityTextField = UITextField()
    private let priceTextField = UITextField()
    
    // MARK: - Disposed Bag
    
    let disposeBag = DisposeBag()
    
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
        addSubview(checkButton)
        addSubview(titleTextField)
        addSubview(quantityTextField)
        addSubview(priceTextField)
        
        addViewConstraints()
        viewConfiguration()
        bindingData()
    }
    
    private func viewConfiguration()
    {
        checkButton.setImage(#imageLiteral(resourceName: "icon-uncheck"), for: .normal)
        checkButton.setImage(#imageLiteral(resourceName: "icon-check"), for: .selected)
        
        titleTextField.borderStyle = .roundedRect
        titleTextField.placeholder = "ชื่ออาหาร/สิ่งของ&รายละเอียด"
        titleTextField.isEnabled = false
        
        quantityTextField.borderStyle = .roundedRect
        quantityTextField.placeholder = "ชิ้น"
        quantityTextField.isEnabled = false
        
        priceTextField.borderStyle = .roundedRect
        priceTextField.placeholder = "บาท"
        priceTextField.isEnabled = false
    }
    
    // MARK: Constraints
    
    private func addViewConstraints()
    {
        checkButton
            .snp
            .makeConstraints {
                $0.leading.equalToSuperview()
                $0.centerY.equalTo(titleTextField.snp.centerY)
                $0.size.equalTo(20.0) }
        
        titleTextField
            .snp
            .makeConstraints {
                $0.leading.equalTo(checkButton.snp.trailing).offset(8.0)
                $0.top.equalToSuperview()
                $0.bottom.equalToSuperview()
        }
        
        quantityTextField
            .snp
            .makeConstraints {
                $0.top.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.leading.equalTo(titleTextField.snp.trailing).offset(8.0)
                $0.width.equalTo(36.0)
        }
        
        priceTextField
            .snp
            .makeConstraints {
                $0.top.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.leading.equalTo(quantityTextField.snp.trailing).offset(8.0)
                $0.trailing.equalToSuperview()
                $0.width.equalTo(72.0)
        }
    }
}

extension ItemCheckView
{
    func bindingData()
    {
        checkButton
            .rx
            .tap
            .scan(false) { lastState, newValue in
                return !lastState }
            .bind(to: checkButton.rx.isSelected)
            .disposed(by: disposeBag)
    }
    
    func didSetViewState(_ oldValue: Bool)
    {
        if isAllowEditing
        {
            checkButton.setImage(#imageLiteral(resourceName: "icon-check"), for: .selected)
            checkButton.isUserInteractionEnabled = true
        }
        else
        {
            checkButton.setImage(#imageLiteral(resourceName: "icon-check-disable"), for: .selected)
            checkButton.isUserInteractionEnabled = false
        }
    }
}

extension Reactive where Base: ItemCheckView
{
    public var check: ControlEvent<Void> { return base.checkButton.rx.tap }
}
