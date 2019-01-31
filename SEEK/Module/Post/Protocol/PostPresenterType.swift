//
//  PostPresenterType.swift
//  SEEK
//
//  Created by oatThanut on 30/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import RxSwift
import UIKit

protocol PostPresenterType: PresenterType
{
    var postsObservable: Observable<Post?> { get }
    
    func loadPostDetail() -> Observable<Void>
}
