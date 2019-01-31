//
//  PostViewController.swift
//  SEEK
//
//  Created by oatThanut on 29/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class PostViewController: UIViewController, PostViewType
{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    
    public let postsBehaviorRelay = BehaviorRelay<Post?>(value: nil)
    
    // MARK: - Disposed Bag
    
    let disposeBag = DisposeBag()
    
    // MARK: - Presenter
    
    var presenter: PostPresenterType
    
    required init?(coder aDecoder: NSCoder)
    {
        self.presenter = PostPresenter()
        
        presenter
            .loadPostDetail()
            .subscribe()
            .disposed(by: disposeBag)
        
        super.init(coder: aDecoder)
    }
    
    // MARK: - View's Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        bindingDataWithPresenter()
        viewConfiguration()
    }
    
    func bindingDataWithPresenter()
    {
        presenter
            .postsObservable
            .filter { $0 != nil }
            .do(
                onNext: { [weak self] in
                    self?.postsBehaviorRelay.accept($0) })
            .subscribe(
                onNext: { [weak self] _ in
                     self?.viewConfiguration() })
            .disposed(by: disposeBag)
    }
    
    func viewConfiguration()
    {
        guard let post = postsBehaviorRelay.value else
        {
            return
        }
        
        print(">> \(post)")
        nameLabel.text = post.postId
        locationLabel.text = post.location
        destinationLabel.text = post.destination
        noteLabel.text = post.note
        storeNameLabel.text = post.storeName
        tipLabel.text = "\(post.tip ?? 0.0)"
    }
}
