//
//  PostViewType.swift
//  SEEK
//
//  Created by oatThanut on 30/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import UIKit

protocol PostViewType: ViewType
{
    var presenter: PostPresenterType? { get }
}
