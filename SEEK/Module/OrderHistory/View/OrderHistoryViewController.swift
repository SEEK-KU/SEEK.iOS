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
    
    public let historyType = "requester"
    
    // MARK: - Disposed Bag
    
    let disposeBag = DisposeBag()
    
    // MARK: - Presenter
    
    let presenter: OrderHistoryPresenterType
    
    required init?(coder aDecoder: NSCoder)
    {
        self.presenter = OrderHistoryPresenter()
        
        presenter
            .loadOrderHistory(
                historyType: historyType)
            .subscribe()
            .disposed(by: disposeBag)
        
        super.init(coder: aDecoder)
        
        title = "My Request"
    }
    
    override func viewDidLoad()
    {
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
                    .loadOrderHistory(
                        historyType: self.historyType)
                    .catchErrorJustReturn([]) }
            .subscribe(
                onNext: { _ in refreshControl.endRefreshing() },
                onError: { _ in refreshControl.endRefreshing() })
            .disposed(by: disposeBag)
        
        collectionView.refreshControl = refreshControl
    }
}
