//
//  CreatePostPresenterType.swift
//  SEEK
//
//  Created by oatThanut on 3/3/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity
import UIKit

protocol CreatePostPresenterType
{
    func createNewPost(
        title: String,
        location: String,
        storeName: String,
        shippingPoint: String,
        itemList: [Entity.Post.ItemList],
        itemQty: Double,
        tip: Double,
        note: String)
}
