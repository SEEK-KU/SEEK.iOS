//
//  TransactionPresenter.swift
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

class TransactionPresenter: TransactionPresenterType
{   
    var studentId = ""
    
    // MARK: - Interactor
    
    let profileInteractor = Interactor.Profile()
    
    // MARK: - Router
    
    let profileRouter = ProfileRouter()
    
    // MARK: - Disposed Bag
    
    let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    required init(
        studentId: String)
    {
        self.studentId = studentId
    }
    
    func loadUserQR() -> Observable<String>
    {
        return profileInteractor
            .rx
            .loadUserQR()
            .asObservable()
    }
    
    func uploadUserQR(imageURL: String)
    {
        return profileInteractor
            .rx
            .uploadUserQR(imageURL: imageURL)
            .subscribe()
            .disposed(by: disposeBag)
    }
}
