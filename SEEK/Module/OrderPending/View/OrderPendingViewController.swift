//
//  OrderPendingViewController.swift
//  SEEK
//
//  Created by oatThanut on 8/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity
import RxCocoa
import RxSwift
import Shared
import UIKit

class OrderPendingViewController: UIViewController
{
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var itemListStackView: UIStackView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    private let items: [ItemListView] = [
        ItemListView(title: "รายการที่ 1"),
        ItemListView(title: "รายการที่ 2"),
        ItemListView(title: "รายการที่ 3"),
        ItemListView(title: "รายการที่ 4"),
        ItemListView(title: "รายการที่ 5") ]
    
    private let grandTotalView = GrandTotalView()
    
    let postsBehaviorRelay = BehaviorRelay<Post?>(value: nil)
    let requesterBehaviorRelay = BehaviorRelay<User?>(value: nil)
    
    // MARK: - Presenter
    
    var presenter: OrderPendingPresenterType?
    
    // MARK: - Disposed Bag
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        items.forEach { [weak self] in
            self?.itemListStackView.addArrangedSubview($0) }
        
        grandTotalView.buttonName = "ยืนยันราคาสินค้า"
        bottomView.addSubview(grandTotalView)
        
        bindingDataWithPresenter()
        viewConfiguration()
        addViewConstraints()
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
            .loadPostDetail(postId: postsBehaviorRelay.value?.postId ?? "")
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
        
        presenter?
            .userProfileImagePublishSubject
            .subscribe(
                onNext: { [weak self] in
                    self?.profileImageView.image = $0 })
            .disposed(by: disposeBag)
        
        cancelButton
            .rx
            .tap
            .do(
                onNext: { [weak self] in
                    self?.presenter?.cancleOrder() })
            .subscribe(
                onNext: { [weak self] in
                    self?.navigationController?.popToRootViewController(animated: true) })
            .disposed(by: disposeBag)
        
        grandTotalView
            .rx
            .tap
            .do(
                onNext: { [weak self] in
                    self?.presenter?.updatePost() })
            .subscribe(
                onNext: { [weak self] in
                    self?.navigationController?.popToRootViewController(animated: true) })
            .disposed(by: disposeBag)
        
        items
            .enumerated()
            .forEach { (offset, element) in
                element
                    .rx
                    .didPriceChanged
                    .subscribe(
                        onNext: { [weak self] in
                            guard let newPrice = $0,
                                newPrice.isEmpty == false else
                            {
                                return
                            }
                            
                            self?.presenter?
                                .updateItemPrice(
                                    newPrice: newPrice,
                                    itemIndex: offset) })
                    .disposed(by: disposeBag) }
    }
    
    func viewConfiguration()
    {
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        
        grandTotalView.layer.shadowColor = UIColor.gray.cgColor
        grandTotalView.layer.shadowOpacity = 0.2
        grandTotalView.layer.shadowOffset = CGSize(width: 0, height: -3)
        grandTotalView.layer.shadowRadius = 3
        
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
                
                self?.items[offset].isAbleToEditPrice = true
                self?.items[offset].itemName = element.name
                self?.items[offset].itemPrice = String(format:"%.2f", element.price ?? "")
                self?.items[offset].itemQuantity = String(format:"%d", element.qty ?? "") }
        
        grandTotalView.price = String(format: "%.2f", totalPrice)
    }
    
    // MARK: Constraints
    
    private func addViewConstraints()
    {
        grandTotalView
            .snp
            .makeConstraints {
                $0.edges.equalToSuperview() }
    }
    
}
