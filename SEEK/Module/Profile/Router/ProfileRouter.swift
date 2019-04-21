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
    
    func navigateToMyTransactionDetail(
        studentId: String,
        from sourceViewController: UIViewController)
    {
        let transactionPresenter = TransactionPresenter(studentId: studentId)
        
        let transactionViewController = storyBoard
            .instantiateViewController(withIdentifier: "Transaction") as! TransactionViewController
        
        transactionViewController.presenter = transactionPresenter
    
        sourceViewController
            .navigationController?
            .pushViewController(
                transactionViewController,
                animated: true)
    }
    
    func navigateToMyRequestHistory(from sourceViewController: UIViewController)
    {
        let presenter = OrderHistoryPresenter(historyType: "requester")
        
        let orderHistoryViewController = storyBoard
            .instantiateViewController(withIdentifier: "OrderHistory") as! OrderHistoryViewController
        
        orderHistoryViewController.title = "My Request"
        orderHistoryViewController.presenter = presenter
        
        sourceViewController
            .navigationController?
            .pushViewController(
                orderHistoryViewController,
                animated: true)
    }
    
    func navigateToMyDeliveryHistory(from sourceViewController: UIViewController)
    {
        let presenter = OrderHistoryPresenter(historyType: "deliverer")
        
        let orderHistoryViewController = storyBoard
            .instantiateViewController(withIdentifier: "OrderHistory") as! OrderHistoryViewController
        
        orderHistoryViewController.title = "My Deliver"
        orderHistoryViewController.presenter = presenter
        
        sourceViewController
            .navigationController?
            .pushViewController(
                orderHistoryViewController,
                animated: true)
    }
}
