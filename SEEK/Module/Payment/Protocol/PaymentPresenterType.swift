//
//  PaymentPresenterType.swift
//  SEEK
//
//  Created by preawbnp on 18/4/2562 BE.
//  Copyright © 2562 oatThanut. All rights reserved.
//

import Foundation
import Entity
import RxSwift
import UIKit

protocol PaymentPresenterType: PresenterType
{
    var orderId: String { get }
    var totalPrice: String { get }
    
    init(
        totalPrice: Double,
        orderId: String)
    
    func uploadOrderSlip(
        orderId: String,
        imageURL: String)
}
