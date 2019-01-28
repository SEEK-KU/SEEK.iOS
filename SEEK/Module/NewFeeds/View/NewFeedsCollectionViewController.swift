//
//  NewFeedsCollectionView.swift
//  SEEK
//
//  Created by oatThanut on 21/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class NewFeedsCollectionView: UICollectionView
{
    public let postsBehaviorRelay = BehaviorRelay<[Post?]>(value: [])
    
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
        
        self.backgroundColor = UIColor.lightGray
        
        self.alwaysBounceVertical = true
        
        delegate = self
        dataSource = self
    }
}

extension NewFeedsCollectionView: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return postsBehaviorRelay.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: PostCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewFeedsCollectionViewCell", for: indexPath) as! PostCollectionViewCell
        
        cell.title = postsBehaviorRelay.value[indexPath.item]?.title ?? ""
        
        return cell
    }
    
    
}

extension NewFeedsCollectionView: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.bounds.width - ( 16.0 * 2 ), height: 100.0)
    }
}

extension Reactive where Base: NewFeedsCollectionView
{
    var postsBehaviorRelay: BehaviorRelay<[Post?]> { return base.postsBehaviorRelay }
}
