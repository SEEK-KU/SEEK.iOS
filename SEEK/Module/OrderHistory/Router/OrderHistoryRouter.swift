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
        orderId: String,
        from sourceViewController: UIViewController)
    {
//        let presenter = OrderProcessingPresenter()
        
        let orderProcessingViewController = storyBoard
            .instantiateViewController(withIdentifier: "OrderProcessing") as! OrderProcessingViewController
        
//        orderProcessingViewController.presenter = presenter
        
        sourceViewController
            .navigationController?
            .pushViewController(
                orderProcessingViewController,
                animated: true)
    }
    
    func navigateToOrderProcessingAsDeliverer(
        orderId: String,
        from sourceViewController: UIViewController)
    {
        //        let presenter = OrderProcessingPresenter()
        
        let orderProcessingViewController = storyBoard
            .instantiateViewController(withIdentifier: "OrderProcessing") as! OrderProcessingViewController
        
        //        orderProcessingViewController.presenter = presenter
        
        sourceViewController
            .navigationController?
            .pushViewController(
                orderProcessingViewController,
                animated: true)
    }
}
