//
//  NewFeedsViewController.swift
//  SEEK
//
//  Created by oatThanut on 21/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity
import RxSwift
import RxCocoa
import UIKit

class NewFeedsViewController: UIViewController, NewFeedsViewType
{
    
    @IBOutlet weak var collectionView: NewFeedsCollectionView!
    
    public let postsBehaviorRelay = BehaviorRelay<[Post?]>(value: [])
    
    // MARK: - Disposed Bag
    
    let disposeBag = DisposeBag()
    
    // MARK: - Presenter
    
    let presenter: NewFeedsPresenterType
    
    required init?(coder aDecoder: NSCoder)
    {
        self.presenter = NewFeedsPresenter()
        
        presenter
            .loadNewFeeds()
            .subscribe()
            .disposed(by: disposeBag)
        
        super.init(coder: aDecoder)
        
        title = "Newsfeed"
    }
    
    // MARK: - View's Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        commonInit()
        bindingDataWithPresenter()
        refreshControlConfiguration()
    }
    
    func commonInit()
    {
        
    }
    
    func bindingDataWithPresenter()
    {
        presenter
            .postsObservable
            .do(onNext: { [unowned self] in self.postsBehaviorRelay.accept($0) })
            .do( onNext: { [unowned self] in self.collectionView.rx.postsBehaviorRelay.accept($0) })
            .subscribe(
                onNext: { [weak self] _ in
                    self?.collectionView.reloadData() })
            .disposed(by: disposeBag)
    }
    
    func refreshControlConfiguration()
    {
        let refreshControl = UIRefreshControl()
        
        refreshControl
            .rx
            .controlEvent(.valueChanged)
            .flatMap { [unowned self] in
                self.presenter
                    .loadNewFeeds()
                    .catchErrorJustReturn([]) }
            .subscribe(
                onNext: { _ in refreshControl.endRefreshing() },
                onError: { _ in refreshControl.endRefreshing() })
            .disposed(by: disposeBag)
        
        collectionView.refreshControl = refreshControl
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "navigateToPost"
        {
            guard let postViewController:PostViewController = segue.destination as? PostViewController else { return }
            
            
            guard let indexPath = self.collectionView?.indexPathsForSelectedItems?.first?.item else { return }
            
            let post = self.postsBehaviorRelay.value[indexPath]
            
            postViewController.title = post?.title
            postViewController.presenter = PostPresenter(postId: post?.postId ?? "")
        }
    }

}
