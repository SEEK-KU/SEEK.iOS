//
//  OrderHistoryRouter.swift
//  SEEK
//
//  Created by oatThanut on 21/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import UIKit

class OrderHistoryRouter
{
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    func navigateToOrderProcessingAsRequester(
        title: String,
        orderId: String,
        from sourceViewController: UIViewController)
    {
        let presenter = OrderProcessingPresenter(orderId: orderId)
        
        let orderProcessingViewController = storyBoard
            .instantiateViewController(withIdentifier: "OrderProcessing") as! OrderProcessingViewController
        
        orderProcessingViewController.presenter = presenter
        
        orderProcessingViewController.title = title
        
        sourceViewController
            .navigationController?
            .pushViewController(
                orderProcessingViewController,
                animated: true)
    }
    
    func navigateToOrderProcessingAsDeliverer(
        title: String,
        orderId: String,
        from sourceViewController: UIViewController)
    {
                let presenter = OrderProcessingPresenter(orderId: orderId)
        
        let orderProcessingViewController = storyBoard
            .instantiateViewController(withIdentifier: "OrderProcessing") as! OrderProcessingViewController
        
        orderProcessingViewController.presenter = presenter
        
        orderProcessingViewController.title = title
        
        sourceViewController
            .navigationController?
            .pushViewController(
                orderProcessingViewController,
                animated: true)
    }
}
