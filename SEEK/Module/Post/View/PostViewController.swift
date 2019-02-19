//
//  PostViewController.swift
//  SEEK
//
//  Created by oatThanut on 29/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity
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
    
    let postsBehaviorRelay = BehaviorRelay<Post?>(value: nil)
    let requesterBehaviorRelay = BehaviorRelay<User?>(value: nil)
    
    // MARK: - Disposed Bag
    
    let disposeBag = DisposeBag()
    
    // MARK: - Presenter
    
    var presenter: PostPresenterType? = nil
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View's Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        presenter?
            .loadPostDetail()
            .subscribe()
            .disposed(by: disposeBag)
        
        bindingDataWithPresenter()
        viewConfiguration()
    }
    
    func bindingDataWithPresenter()
    {
        presenter?
            .postsObservable
            .filter { $0 != nil }
            .do(
                onNext: { [weak self] in
                    self?.postsBehaviorRelay.accept($0) })
            .subscribe(
                onNext: { [weak self] _ in
                     self?.viewConfiguration() })
            .disposed(by: disposeBag)
        
        presenter?
            .requesterObservable
            .filter { $0 != nil }
            .do(
                onNext: { [weak self] in
                    self?.requesterBehaviorRelay.accept($0) })
            .subscribe(
                onNext: { [weak self] _ in
                    self?.viewConfiguration() })
            .disposed(by: disposeBag)
    }
    
    func viewConfiguration()
    {
        guard let post = postsBehaviorRelay.value,
            let requester = requesterBehaviorRelay.value else
        {
            return
        }
        
        nameLabel.text = requester.firstname
        
        locationLabel.text = post.location
        destinationLabel.text = post.destination
        noteLabel.text = post.note
        storeNameLabel.text = post.storeName
        tipLabel.text = "\(post.tip ?? 0.0)"
    }
}
