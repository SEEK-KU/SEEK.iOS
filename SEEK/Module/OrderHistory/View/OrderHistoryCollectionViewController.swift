//
//  OrderHistoryCollectionViewController.swift
//  SEEK
//
//  Created by oatThanut on 17/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity
import RxCocoa
import RxSwift
import UIKit

class OrderHistoryCollectionViewController: UICollectionView
{
    fileprivate let postsBehaviorRelay = BehaviorRelay<[Post?]>(value: [])
    
    // MARK: - Initializer
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumLineSpacing = 16.0
        collectionViewFlowLayout.minimumInteritemSpacing = 16.0
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(
            top: 16.0,
            left: 16.0,
            bottom: 0.0,
            right: 16.0)
        
        self.collectionViewLayout = collectionViewFlowLayout
        
        self.backgroundColor = .white
        
        self.alwaysBounceVertical = true
        
        delegate = self
        dataSource = self
    }
}

extension OrderHistoryCollectionViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return postsBehaviorRelay.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: PostCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderHistoryCollectionViewCell", for: indexPath) as! PostCollectionViewCell
        
        if let post = postsBehaviorRelay.value[indexPath.item]
        {
            cell.title = post.title ?? ""
            cell.location = post.location ?? ""
            cell.destination = post.shippingPoint ?? ""
            cell.tip = String(format: "%.0f", post.tip ?? 0)
        }
        
        return cell
    }
    
    
}

extension OrderHistoryCollectionViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.bounds.width - ( 16.0 * 2 ), height: 120)
    }
}

extension Reactive where Base: OrderHistoryCollectionViewController
{
    var postsBehaviorRelay: BehaviorRelay<[Post?]> { return base.postsBehaviorRelay }
}
