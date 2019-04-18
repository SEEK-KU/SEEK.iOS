//
//  SignUpViewController.swift
//  SEEK
//
//  Created by oatThanut on 16/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class SignUpViewController: UIViewController
{
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var facultyTextField: UITextField!
    @IBOutlet weak var telephoneTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Dispose Bag
    
    let disposeBag = DisposeBag()
    
    // MARK: - Presenter
    
    var presenter = SignUpPresenter()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        nextButton
            .rx
            .tap
            .flatMap { [unowned self] _ -> Single<Bool> in
                return self.validateUserInfo() }
            .filter { $0 }
            .subscribe(
                onNext: { [unowned self] _ in
                        self.presenter.navigateToRootViewController(from: self) })
            .disposed(by: disposeBag)
    }
    
    func validateUserInfo() -> Single<Bool>
    {
        guard let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let faculty = facultyTextField.text,
            let telephone = telephoneTextField.text else
        {
            return .just(false)
        }
        
        let isFieldEmpty = [
            firstName.isEmpty,
            lastName.isEmpty,
            faculty.isEmpty,
            telephone.isEmpty ]
        
        let error = isFieldEmpty.reduce(false) { $0 || $1 }
        
        if error == false
        {
            presenter
                .signUp(
                    firstName: firstName,
                    lastName: lastName,
                    faculty: faculty,
                    telephone: telephone)
            return .just(true)
        }
        else
        {
            return .just(false)
        }
    }
}
