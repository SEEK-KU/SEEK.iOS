//
//  ProfileRouter.swift
//  SEEK
//
//  Created by oatThanut on 16/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import SwiftKeychainWrapper
import UIKit

class ProfileRouter
{
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    public func navigateToLogin(from sourceViewController: UIViewController)
    {
        KeychainWrapper.standard.remove(key: .ssoToken)
        
        sourceViewController.performSegue(withIdentifier: "LogOut", sender: nil)
    }
    
    func navigateToMyTransactionDetail(from sourceViewController: UIViewController)
    {
        
    }
    
    func navigateToMyRequestHistory(from sourceViewController: UIViewController)
    {
        
        
        let orderHistoryViewController = storyBoard
            .instantiateViewController(withIdentifier: "OrderHistory") as! OrderHistoryViewController
        
        orderHistoryViewController.title = "My Request"
        
        sourceViewController
            .navigationController?
            .pushViewController(
                orderHistoryViewController,
                animated: true)
    }
    
    func navigateToMyDeliveryHistory(from sourceViewController: UIViewController)
    {
        
    }
}
