//
//  CreatePostPresenter.swift
//  SEEK
//
//  Created by oatThanut on 21/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity
import Interactor
import RxCocoa
import RxSwift
import UIKit

class CreatePostPresenter: CreatePostPresenterType
{
    // MARK: - Interactor
    
    let postInteractor = Interactor.Post()
    
    // MARK: - Disposed Bag
    
    let disposeBag = DisposeBag()
    
    required init()
    {
        
    }
    
    public func createNewPost(
        title: String,
        location: String,
        storeName: String,
        shippingPoint: String,
        itemQty: Double,
        tip: Double,
        note: String)
    {
//        guard let userId = UserDefaults.standard.object(forKey: "userId") as? String else
//        {
//            return
//        }
        
        let userId = "5810545947"
        
        let order = Entity.Post(
            title: title,
            requesterId: userId,
            location: location,
            storeName: storeName,
            shippingPoint: shippingPoint,
            itemQty: itemQty,
            tip: tip,
            note: note)
        
        postInteractor
            .rx
            .createNewPost(
                order: order)
            .subscribe()
            .disposed(by: disposeBag)
    }
}



