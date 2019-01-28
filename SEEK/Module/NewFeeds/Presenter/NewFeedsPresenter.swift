//
//  NewFeedsPresenter.swift
//  SEEK
//
//  Created by oatThanut on 21/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya
import UIKit

class NewFeedsPresenter: NewFeedsPresenterType
{
    let postsBehaviorRelay = BehaviorRelay<[Post?]>(value: [])
    
    var postsObservable: Observable<[Post?]> {
        return postsBehaviorRelay.asObservable()
    }
    
    // MARK: - Interactor
    
    let provider = MoyaProvider<Interactor>()
    
    // MARK: - Disposed Bag
    
    let disposeBag = DisposeBag()
    
    func loadNewFeeds() -> Observable<Void>
    {
        return provider
            .rx
            .request(.feeds)
            .mapJSON()
            .asObservable()
            .do(
                onNext: { [unowned self] response in
                    guard let response = (response as? [[String: Any]])?.map(Post.init) else
                    {
                        return
                    }
                    
                    self.postsBehaviorRelay.accept(response) })
            .map { _ in }
    }
    
}

struct Starwar: DictionaryDecodableType, Codable, Equatable
{
    public let name: String?
    
    init?(data: [String : Any]?)
    {
        guard let data = data else
        {
            return nil
        }
        
        guard data.isEmpty == false else
        {
            return nil
        }
        
        let name = data["name"] as? String
        
        self.init(
            name: name)
    }
    
    public init(
        name: String? = nil)
    {
        self.name = name
    }
}
