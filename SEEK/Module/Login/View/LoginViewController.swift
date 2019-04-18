//
//  LoginViewController.swift
//  SEEK
//
//  Created by oatThanut on 14/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class LoginViewController: UIViewController
{
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Dispose Bag
    
    let disposeBag = DisposeBag()
    
    // MARK: - Presenter
    
    var presenter = LoginPresenter()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        bindingData()
    }
    
    func bindingData()
    {
         presenter
            .isTokenExist()
            .filter { $0 }
            .subscribe(
                onSuccess: { [unowned self] _ in
                    self.presenter.navigateToRootViewController(from: self) })
            .disposed(by: disposeBag)
        
        presenter
            .shouldEnterUserInfoObservable
            .subscribe(
                onNext: { [unowned self] in
                    guard let shouldEnterUserInfo = $0 else
                    {
                        return
                    }
                    
                    if shouldEnterUserInfo
                    {
                        self.presenter.navigateToSignUp(from: self)
                    }
                    else
                    {
                        self.presenter.navigateToRootViewController(from: self)
                    } })
            .disposed(by: disposeBag)
        
        loginButton
            .rx
            .tap
            .do(
                onNext: { [weak self] in
                    self?.loginButton.isEnabled = false })
            .subscribe(
                onNext: { [weak self] in
                    guard let username = self?.userIdTextField.text,
                        let password = self?.passwordTextField.text else
                    {
                        return
                    }
                    
                    self?.presenter
                        .login(
                            username: username,
                            password: password)
                    
                    self?.loginButton.isEnabled = true })
            .disposed(by: disposeBag)
    }
}
