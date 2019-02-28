//
//  RootTabBarViewController.swift
//  SEEK
//
//  Created by oatThanut on 18/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import UIKit

class RootTabBarViewController: UITabBarController
{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.delegate = self
    }
    

}

extension RootTabBarViewController: UITabBarControllerDelegate
{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool
    {
        if viewController.children.first(where: { $0 is CreatePostViewController }) != nil
        {
            if let presentingViewController = tabBarController.storyboard?.instantiateViewController(withIdentifier: "CreatePost")
            {
                tabBarController.present(presentingViewController, animated: true)
                return false
            }
        }
        
        return true
    }

}
