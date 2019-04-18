//
//  LoginRouter.swift
//  SEEK
//
//  Created by oatThanut on 15/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import UIKit

class LoginRouter
{
    public func navigateToRootViewController(
        from sourceViewController: UIViewController)
    {
        DispatchQueue.main.async(){
            sourceViewController.performSegue(withIdentifier: "RootView", sender: nil)
        }
    }
    
    public func navigateToSignUp(
        from sourceViewController: UIViewController)
    {
        sourceViewController.performSegue(withIdentifier: "SignUp", sender: nil)
    }
}
