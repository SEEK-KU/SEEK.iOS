//
//  SignUpRouter.swift
//  SEEK
//
//  Created by oatThanut on 16/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import UIKit

class SignUpRouter
{
    public func navigateToRootViewController(
        from sourceViewController: UIViewController)
    {
        sourceViewController
            .performSegue(
                withIdentifier: "RootView",
                sender: nil)
    }
}
