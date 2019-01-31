//
//  PostPresenter.swift
//  SEEK
//
//  Created by oatThanut on 30/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import RxCocoa
import RxSwift
import Moya
import UIKit

class PostPresenter: PostPresenterType
{
    let postsBehaviorRelay = BehaviorRelay<Post?>(value: nil)
    
    var postsObservable: Observable<Post?> {
        return postsBehaviorRelay.asObservable()
    }
    
    // MARK: - Interactor
    
    let provider = MoyaProvider<Interactor>()
    
    // MARK: - Disposed Bag
    
    let disposeBag = DisposeBag()
    
    func loadPostDetail() -> Observable<Void>
    {
        return provider
            .rx
            .request(.order)
            .mapJSON()
            .asObservable()
            .do(onNext: { [unowned self] response in
                guard let response = (response as? [String: Any]).map(Post.init) else
                {
                    return
                }
                
                self.postsBehaviorRelay.accept(response) })
            .map { _ in }
    }
}
