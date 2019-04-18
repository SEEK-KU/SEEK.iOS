//
//  PostRouter.swift
//  SEEK
//
//  Created by oatThanut on 7/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity
import Interactor
import UIKit

class PostRouter
{
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    public func navigateToOrderPending(
        from sourceViewController: UIViewController,
        post: Entity.Post?)
    {
        
        let presenter = OrderPendingPresenter(
            postViewModel: post)
        
        
        let orderPendingViewController = storyBoard
            .instantiateViewController(withIdentifier: "OrderPending") as! OrderPendingViewController
        orderPendingViewController.presenter = presenter
        
        sourceViewController
            .navigationController?
            .pushViewController(
                orderPendingViewController,
                animated: true)
    }
}
