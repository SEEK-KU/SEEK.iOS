//
//  OrderProcessingViewController.swift
//  SEEK
//
//  Created by oatThanut on 14/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity
import RxCocoa
import RxSwift
import Shared
import SnapKit
import UIKit

class OrderProcessingViewController: UIViewController
{
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var itemStackView: UIStackView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    private let orderStatus = OrderStatusBarView()
    
    private let items: [ItemCheckView] = [
        ItemCheckView(),
        ItemCheckView(),
        ItemCheckView(),
        ItemCheckView(),
        ItemCheckView() ]
    
    private let grandTotalView = GrandTotalView()
    
    let postsBehaviorRelay = BehaviorRelay<Post?>(value: nil)
    let requesterBehaviorRelay = BehaviorRelay<User?>(value: nil)
    
    // MARK: - Presenter
    
    var presenter: OrderProcessingPresenterType?
    
    // MARK: - Disposed Bag
    
    let disposeBag = DisposeBag()
    
    // MARK: - View's life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        items.forEach { [weak self] in
            self?.itemStackView.addArrangedSubview($0) }
        
        topView.addSubview(orderStatus)
        bottomView.addSubview(grandTotalView)
        
        bindingDataWithPresenter()
        addViewConstraints()
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
//            .loadPostDetail(postId: postsBehaviorRelay.value?.postId ?? "")
            .loadPostDetail(postId: "5cadbf878315751a0fbf9f96")
            .subscribe()
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
    
    private func viewConfiguration()
    {
        guard let post = postsBehaviorRelay.value,
            let requester = requesterBehaviorRelay.value else
        {
            return
        }
        
        let requesterName = "\(requester.firstname ?? "") \(requester.lastname ?? "")"
        nameLabel.text = requesterName
        
        locationLabel.text = post.location
        destinationLabel.text = post.shippingPoint
        noteLabel.text = post.note
        storeNameLabel.text = post.storeName
        tipLabel.text = "\(post.tip ?? 0.0)"
        
        updateItemList()
    }
    
    func updateItemList()
    {
        guard let post = postsBehaviorRelay.value else
        {
            return
        }
        
        var totalPrice = 0.0
        
        post
            .itemList?
            .enumerated()
            .forEach { [weak self] (offset, element) in
                totalPrice += ((element.price ?? 0.0) * Double(element.qty ?? 0))
                
                self?.items[offset].itemPrice = String(format:"%.2f", element.price ?? "")
                self?.items[offset].itemQuantity = String(format:"%d", element.qty ?? "") }
        
        grandTotalView.price = String(format: "%.2f", totalPrice)
    }
    
    // MARK: Constraints
    
    private func addViewConstraints()
    {
        orderStatus
            .snp
            .makeConstraints {
                $0.edges.equalToSuperview() }
    }
}
