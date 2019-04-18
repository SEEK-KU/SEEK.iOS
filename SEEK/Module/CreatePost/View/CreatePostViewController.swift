//
//  CreatePostViewController.swift
//  SEEK
//
//  Created by oatThanut on 21/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import ActionSheetPicker_3_0
import Entity
import RxCocoa
import RxSwift
import Shared
import SnapKit
import UIKit

class CreatePostViewController: UIViewController, CreatePostViewType
{
    // MARK: - Subviews
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var postTitleTextField: UITextField!
    @IBOutlet weak var locationDropdown: UITextField!
    @IBOutlet weak var shippingPointDropdown: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var storeNameTextField: UITextField!
    @IBOutlet weak var tipsTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var closeBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var itemStackView: UIStackView!
    
    private let items: [ItemListView] = [
        ItemListView(title: "รายการที่ 1"),
        ItemListView(title: "รายการที่ 2"),
        ItemListView(title: "รายการที่ 3"),
        ItemListView(title: "รายการที่ 4"),
        ItemListView(title: "รายการที่ 5") ]
    
    private let locationTags = [
        "โรงอาหารกลาง1(บาร์ใหม่)",
        "โรงอาหารกลาง2(บาร์ใหม่กว่า)",
        "โรงอาหารคณะวิศวกรรมศาสตร์(บาร์วิศวะ)",
        "โรงอาหารคณะวิทยาศาสตร์(บาร์วิทย์)",
        "โรงอาหารคณะบริหาร(บาร์บริหาร)",
        "โรงอาหารคณะเศรษฐศาสตร์(บาร์เศรษฐศาสตร์)",
        "อาคสรจอดรถประตูงามวงศ์วาน1" ]
    
    // MARK: - Disposed Bag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Presenter
    
    var presenter: CreatePostPresenterType? = nil
    
    required init?(coder aDecoder: NSCoder)
    {
        self.presenter = CreatePostPresenter()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Post"
        
        locationDropdown.delegate = self
        shippingPointDropdown.delegate = self
        
        items.forEach { [weak self] in
            $0.isCreatingMode = true
            self?.itemStackView.addArrangedSubview($0) }
        
        view.setNeedsLayout()
        
        viewConfiguration()
        bindingData()
    }
    
    func bindingData()
    {
        createButton
            .rx
            .tap
            .do(
                onNext: { [unowned self] in
                    let title = self.postTitleTextField.text ?? ""
                    let location = self.locationDropdown.text ?? ""
                    let storeName = self.storeNameTextField.text ?? ""
                    let shippingPoint = self.shippingPointDropdown.text ?? ""
                    let itemQty = 0.0
                    let tip = Double(self.tipsTextField.text ?? "") ?? 0.0
                    let note = self.noteTextField.text ?? ""
                    
                    var itemList: [Entity.Post.ItemList] = []
                    self.items
                        .forEach{
                            guard let itemName = $0.itemName,
                                let itemPrice = $0.itemPrice,
                                let itemQuantity = $0.itemQuantity,
                                itemName.isEmpty == false,
                                itemPrice.isEmpty == false,
                                itemQuantity.isEmpty == false
                            else
                            {
                                return
                            }
                            
                            itemList.append(Post.ItemList(
                                name: itemName,
                                price: Double(itemPrice) ?? 0.0,
                                qty: Int(itemQuantity) ?? 0 )) }
                    
                    self.presenter?
                        .createNewPost(
                            title: title,
                            location: location,
                            storeName: storeName,
                            shippingPoint: shippingPoint,
                            itemList: itemList,
                            itemQty: itemQty,
                            tip: tip,
                            note: note) })
            .subscribe(
                onNext: { [weak self] in
                    self?.dismiss(animated: true, completion: nil) })
            .disposed(by: disposeBag)
        
        closeBarButtonItem
            .rx
            .tap
            .subscribe(
                onNext: { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
            } )
            .disposed(by: disposeBag)
    }
    
    func viewConfiguration()
    {
        createButton.backgroundColor = UIColor(red:0, green:0.53, blue:1, alpha:1)
        createButton.layer.cornerRadius = 8.0
    }

}

extension CreatePostViewController: UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == self.locationDropdown
        {
            view.endEditing(true)
            
            ActionSheetStringPicker.show(
                withTitle: "Select location",
                rows: locationTags,
                initialSelection: 0,
                doneBlock: { (_, index, value) in
                    guard 0..<self.locationTags.count ~= index else
                    {
                        return
                    }
                    
                    self.locationDropdown.text = self.locationTags[index]
            },
                cancel: { _ in },
                origin: self.locationDropdown)
            
            return false
        }
        
        if textField == self.shippingPointDropdown
        {
            view.endEditing(true)
            
            ActionSheetStringPicker.show(
                withTitle: "Select destination",
                rows: locationTags,
                initialSelection: 0,
                doneBlock: { (_, index, value) in
                    guard 0..<self.locationTags.count ~= index else
                    {
                        return
                    }
                    
                    self.shippingPointDropdown.text = self.locationTags[index]
            },
                cancel: { _ in },
                origin: self.shippingPointDropdown)
            
            return false
        }
        
        return true
    }
}
