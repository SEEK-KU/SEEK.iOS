//
//  PaymentPresenterType.swift
//  SEEK
//
//  Created by preawbnp on 17/4/2562 BE.
//  Copyright © 2562 oatThanut. All rights reserved.
//

import Entity
import RxSwift
import UIKit

protocol TransactionPresenterType: PresenterType
{
    var studentId: String { get }
    
    init(studentId: String)
    
    func loadUserQR() -> Observable<String>
    func uploadUserQR(imageURL: String)
}
