//
//  NewFeedsPresenterType.swift
//  SEEK
//
//  Created by oatThanut on 24/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity
import RxSwift
import UIKit

protocol NewFeedsPresenterType: PresenterType
{
    var postsObservable: Observable<[Post?]> { get }
    
    func loadNewFeeds() -> Observable<[Post?]>
}
