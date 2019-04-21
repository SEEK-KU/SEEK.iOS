//
//  OrderHistoryViewController.swift
//  SEEK
//
//  Created by oatThanut on 17/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity
import RxCocoa
import RxSwift
import UIKit

class OrderHistoryViewController: UIViewController
{
    
    @IBOutlet weak var collectionView: OrderHistoryCollectionViewController!
    
    public let postsBehaviorRelay = BehaviorRelay<[Post?]>(value: [])
    
    // MARK: - Disposed Bag
    
    let disposeBag = DisposeBag()
    
    // MARK: - Presenter
    
    var presenter: OrderHistoryPresenterType?
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        presenter?
            .loadOrderHistory()
            .subscribe()
            .disposed(by: disposeBag)
        
        bindingDataWithPresenter()
        refreshControlConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        navigationController?.navigationBar.prefersLargeTitles = false
        
        super.viewWillDisappear(animated)
    }
    
    func bindingDataWithPresenter()
    {
        collectionView
            .rx
            .itemSelected
            .subscribe(
                onNext: { [unowned self] in
                    guard let postId = self.postsBehaviorRelay.value[$0.item]?.postId else
                    {
                        return
                    }
                    
                    self.presenter?.navigateToOrderProcessing(
                        orderId: postId,
                        from: self) })
        
        presenter?
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
        
        guard let presenter = self.presenter else
        {
            return
        }
        
        refreshControl
            .rx
            .controlEvent(.valueChanged)
            .flatMap { _ in
                (presenter
                    .loadOrderHistory()
                    .catchErrorJustReturn([])) }
            .subscribe(
                onNext: { _ in refreshControl.endRefreshing() },
                onError: { _ in refreshControl.endRefreshing() })
            .disposed(by: disposeBag)
        
        collectionView.refreshControl = refreshControl
    }
}
