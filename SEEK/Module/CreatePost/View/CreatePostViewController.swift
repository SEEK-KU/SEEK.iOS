//
//  CreatePostViewController.swift
//  SEEK
//
//  Created by oatThanut on 21/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import ActionSheetPicker_3_0
import RxCocoa
import RxSwift
import SnapKit
import UIKit

class CreatePostViewController: UIViewController, CreatePostViewType
{
    // MARK: - Subviews
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var postTitleTextField: UITextField!
    @IBOutlet weak var locationDropdown: UITextField!
    @IBOutlet weak var destinationDropdown: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var storeNameTextField: UITextField!
    @IBOutlet weak var TipsTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var closeBarButtonItem: UIBarButtonItem!
    
    
    
    private let items = ["AA", "BB", "CC"]
    
    // MARK: - Disposed Bag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Presenter
    
    var presenter: CreatePostPresenterType? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Post"
        
        locationDropdown.delegate = self
        destinationDropdown.delegate = self
        
        viewConfiguration()
        bindingData()
    }
    
    func bindingData()
    {
        
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CreatePostViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == self.locationDropdown
        {
            ActionSheetStringPicker.show(
                withTitle: "Select location",
                rows: items,
                initialSelection: 0,
                doneBlock: { (_, index, value) in
                    guard 0..<self.items.count ~= index else
                    {
                        return
                    }
                    
                    self.locationDropdown.text = self.items[index]
            },
                cancel: { _ in },
                origin: self.locationDropdown)
            textField.endEditing(true)
        }
        else if textField == self.destinationDropdown
        {
            ActionSheetStringPicker.show(
                withTitle: "Select destination",
                rows: items,
                initialSelection: 0,
                doneBlock: { (_, index, value) in
                    guard 0..<self.items.count ~= index else
                    {
                        return
                    }
                    
                    self.destinationDropdown.text = self.items[index]
            },
                cancel: { _ in },
                origin: self.destinationDropdown)
            textField.endEditing(true)
        }
        
    }
}
