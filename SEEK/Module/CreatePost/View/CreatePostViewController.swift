//
//  CreatePostViewController.swift
//  SEEK
//
//  Created by oatThanut on 21/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class CreatePostViewController: UIViewController {

//    @IBOutlet weak var closeBarButtonItem: UIBarButtonItem!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Post"
        
//        closeBarButtonItem
//            .rx
//            .tap
//            .subscribe(
//                onNext: { [weak self] in
//                    self?.dismiss(animated: true, completion: nil)
//            } )
//            .disposed(by: disposeBag)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
