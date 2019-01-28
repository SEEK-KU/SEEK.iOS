//
//  NewFeedsViewController.swift
//  SEEK
//
//  Created by oatThanut on 21/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

class NewFeedsViewController: UIViewController, NewFeedsViewType
{
    
    @IBOutlet weak var FilterButton: UIBarButtonItem!
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
            .do( onNext: { [unowned self] in self.collectionView.postsBehaviorRelay.accept($0) })
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
                    .asObservable()
                    .catchErrorJustReturn(()) }
            .subscribe(
                onNext: { _ in refreshControl.endRefreshing() },
                onError: { _ in refreshControl.endRefreshing() })
            .disposed(by: disposeBag)
        
        collectionView.refreshControl = refreshControl
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
