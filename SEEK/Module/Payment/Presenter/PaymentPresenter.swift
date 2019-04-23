//
//  PaymentPresenter.swift
//  SEEK
//
//  Created by preawbnp on 18/4/2562 BE.
//  Copyright © 2562 oatThanut. All rights reserved.
//

import Foundation
import Entity
import Interactor
import RxCocoa
import RxSwift
import UIKit

class PaymentPresenter: PaymentPresenterType
{
    var orderId = ""
    var totalPrice = ""
    
    // MARK: - Interactor
    
    let postInteractor = Interactor.Post()
    
    // MARK: - Router
    
    let profileRouter = ProfileRouter()
    
    // MARK: - Disposed Bag
    
    let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    required init(
        totalPrice: Double,
        orderId: String)
    {
        self.orderId = orderId
        self.totalPrice = "\(totalPrice) บาท"
    }
    
    func uploadOrderSlip(
        orderId: String,
        imageURL: String)
    {
        return postInteractor
            .rx
            .uploadSlip(
                orderId: orderId,
                slipURL: imageURL)
            .flatMap { [unowned self] _ in
                return self.postInteractor
                    .rx
                    .updatePostStatus(
                        orderId: orderId,
                        orderStatus: .accepted) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}
