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
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var itemStackView: UIStackView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var cancleButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private let orderStatusView = OrderStatusBarView()
    
    private let items: [ItemCheckView] = [
        ItemCheckView(),
        ItemCheckView(),
        ItemCheckView(),
        ItemCheckView(),
        ItemCheckView() ]
    
    private let grandTotalView = GrandTotalView()
    
    let postsBehaviorRelay = BehaviorRelay<Post?>(value: nil)
    let requesterBehaviorRelay = BehaviorRelay<User?>(value: nil)
    
    var isAllowEditing: Bool = false
    
    // MARK: - Presenter
    
    var presenter: OrderProcessingPresenterType?
    
    // MARK: - Disposed Bag
    
    let disposeBag = DisposeBag()
    
    // MARK: - View's life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        topView.addSubview(orderStatusView)
        bottomView.addSubview(grandTotalView)
        
        refreshControlConfiguration()
        bindingDataWithPresenter()
        addViewConstraints()
        viewConfiguration()
    }
    
    func bindingDataWithPresenter()
    {
        presenter?
            .loadPostDetail(postId: self.presenter?.orderId)
            .subscribe()
            .disposed(by: disposeBag)
        
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
        
        presenter?
            .userProfileImagePublishSubject
            .subscribe(
                onNext: { [weak self] in
                    self?.profileImageView.image = $0 })
            .disposed(by: disposeBag)
        
        presenter?
            .isAllowEditingPublishSubject
            .do(
                onNext: { [weak self] in
                    self?.isAllowEditing = $0 })
            .subscribe(
                onNext: { [weak self] isAllow in
                    if !isAllow
                    {
                        self?.cancleButton.isHidden = true
                    }
                    
                    self?.items
                        .forEach({ (item) in
                            item.isAllowEditing = isAllow }) })
            .disposed(by: disposeBag)

        presenter?
            .shouldShowButtomViewPublishSubject
            .subscribe(
                onNext: { [weak self] in
                    self?.grandTotalView.isHidden = !$0
                    self?.addViewConstraints()
                    #warning("Fix constraint")
                    self?.scrollView.setNeedsUpdateConstraints()
                    self?.grandTotalView.setNeedsUpdateConstraints()
                    self?.updateViewConstraints() })
            .disposed(by: disposeBag)
        
        presenter?
            .nexButtonTextPublishSubject
            .subscribe(
                onNext: { [weak self] in
                    self?.grandTotalView.buttonTitle = $0 })
            .disposed(by: disposeBag)
        
        items
            .enumerated()
            .forEach { (offset, item) in
                item
                    .rx
                    .check
                    .subscribe(
                        onNext: { [weak self] _ in
                            self?.presenter?
                                .updateItemListCheck(
                                    newItemCheck: item.isSelected,
                                    itemIndex: offset) })
                    .disposed(by: disposeBag) }
        
        cancleButton
            .rx
            .tap
            .subscribe(
                onNext: { [weak self] _ in
                    self?.presenter?.cancleOrder() })
            .disposed(by: disposeBag)
        
        grandTotalView
            .rx
            .tap
            .do(
                onNext: { } )
            .subscribe(
                onNext: { [unowned self] in
                    if self.isAllowEditing
                    {
                        self.updateItemCheck()
                        
                        guard let itemList = self.postsBehaviorRelay.value?.itemList else
                        {
                            return
                        }
                        
                        var totalPrice = 0.0
                        self.items
                            .enumerated()
                            .forEach { (offset, item) in
                            if item.isSelected
                            {
                                totalPrice += ((itemList[offset].price ?? 0.0) * Double(itemList[offset].qty ?? 0))
                            } }
                        
                        self.presenter?
                            .pushPaymentViewController(
                                totalPrice: totalPrice,
                                from: self)
                    }
                    else
                    {
                        self.presenter?.updateOrderProgess()
                    } })
            .disposed(by: disposeBag)
    }
    
    private func viewConfiguration()
    {
        grandTotalView.isHidden = true
        grandTotalView.layer.shadowColor = UIColor.gray.cgColor
        grandTotalView.layer.shadowOpacity = 0.2
        grandTotalView.layer.shadowOffset = CGSize(width: 0, height: -3)
        grandTotalView.layer.shadowRadius = 3
        
        orderStatusView.layer.shadowColor = UIColor.black.cgColor
        orderStatusView.layer.shadowOpacity = 0.2
        orderStatusView.layer.shadowRadius = 3
        orderStatusView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        guard let post = postsBehaviorRelay.value,
            let requester = requesterBehaviorRelay.value else
        {
            return
        }
        
        guard let orderStatus = post.status else
        {
            return
        }
        
        orderStatusView.orderStatus = orderStatus
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        
        let requesterName = "\(requester.firstname ?? "") \(requester.lastname ?? "")"
        nameLabel.text = requesterName
        timeLabel.text = requester.telphone
        
        locationLabel.text = post.location
        destinationLabel.text = post.shippingPoint
        noteLabel.text = post.note
        storeNameLabel.text = post.storeName
        tipLabel.text = "\(post.tip ?? 0.0)"
        
        updateItemList()
    }
    
    func refreshControlConfiguration()
    {
        let refreshControl = UIRefreshControl()
        
        refreshControl
            .rx
            .controlEvent(.valueChanged)
            .flatMap { [unowned self] _ in
                self.presenter?
                    .loadPostDetail(postId: self.postsBehaviorRelay.value?.postId ?? "")
                    .catchErrorJustReturn(()) ?? .just(()) }
            .subscribe(
                onNext: { _ in refreshControl.endRefreshing() },
                onError: { _ in refreshControl.endRefreshing() })
            .disposed(by: disposeBag)
        
        scrollView.refreshControl = refreshControl
    }
    
    func updateItemCheck()
    {
        guard let post = postsBehaviorRelay.value,
            let postItem = post.itemList else
        {
            return
        }
        
        var newItemList: [Entity.Post.ItemList] = []
        
        postItem
            .enumerated()
            .forEach { [weak self] (offset, element) in
                let temp = Entity
                    .Post
                    .ItemList(
                        name: element.name,
                        price: element.price,
                        qty: element.qty,
                        check: self?.items[offset].isSelected)
                newItemList.append(temp) }
        
        presenter?.updateItemList(itemList: newItemList)
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
                
                self?.itemStackView.addArrangedSubview(items[offset])
                
                if element.check ?? false
                {
                    totalPrice += ((element.price ?? 0.0) * Double(element.qty ?? 0))
                }
                
                self?.items[offset].itemName = element.name
                self?.items[offset].itemPrice = String(format:"%.2f", element.price ?? "")
                self?.items[offset].itemQuantity = String(format:"%d", element.qty ?? "")
                self?.items[offset].isSelected = element.check ?? false}
        
        
        grandTotalView.price = String(format: "%.2f", totalPrice)
    }
    
    // MARK: Constraints
    
    private func addViewConstraints()
    {
        orderStatusView
            .snp
            .makeConstraints {
                $0.edges.equalToSuperview() }
        
        grandTotalView
            .snp
            .makeConstraints {
                $0
                    .edges
                    .equalToSuperview() }
        
        scrollView
            .snp
            .makeConstraints {
                if grandTotalView.isHidden
                {
                    $0.bottom.equalToSuperview()
                }
                else
                {
                     $0.bottom.equalTo(bottomView.snp.top)
                }
        }
    }
}
