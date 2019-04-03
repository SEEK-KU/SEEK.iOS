//
//  Post.swift
//  Entity
//
//  Created by oatThanut on 26/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Foundation

public struct Post: DictionaryDecodableType, Codable, Hashable
{
    public let postId: String?
    public let title: String?
    public let requesterId: String?
    public let delivererId: String?
    public let location: String?
    public let storeName: String?
    public let shippingPoint: String?
    public let itemList: [ItemList]?
    public let itemQty: Double?
    public let tip: Double?
    public let note: String?
    public let status: String?
    
    public init?(data: [String : Any]?)
    {
        guard let data = data else
        {
            return nil
        }
        
        guard data.isEmpty == false else
        {
            return nil
        }
        
        let postId = data[.postId] as? String
        let title = data[.title] as? String
        let requesterId = data[.requesterId] as? String
        let delivererId = data[.delivererId] as? String
        let location = data[.location] as? String
        let storeName = data[.storeName] as? String
        let shippingPoint = data[.shippingPoint] as? String
        let itemList = (data[.itemList] as? [[String: Any]])?.compactMap(ItemList.init)
        let itemQty = data[.itemQty] as? Double
        let tip = data[.tip] as? Double
        let note = data[.note] as? String
        let status = data[.status] as? String
        
        self.init(
            postId: postId,
            title: title,
            requesterId: requesterId,
            delivererId: delivererId,
            location: location,
            storeName: storeName,
            shippingPoint: shippingPoint,
            itemList: itemList,
            itemQty: itemQty,
            tip: tip,
            note: note,
            status: status)
    }
    
    public init(
        postId: String? = nil,
        title: String? = nil,
        requesterId: String? = nil,
        delivererId: String? = nil,
        location: String? = nil,
        storeName: String? = nil,
        shippingPoint: String? = nil,
        itemList: [ItemList]? = nil,
        itemQty: Double? = nil,
        tip: Double? = nil,
        note: String? = nil,
        status: String? = nil)
    {
        self.postId = postId
        self.title = title
        self.requesterId = requesterId
        self.delivererId = delivererId
        self.location = location
        self.storeName = storeName
        self.shippingPoint = shippingPoint
        self.itemList = itemList
        self.itemQty = itemQty
        self.tip = tip
        self.note = note
        self.status = status
    }
}

extension String
{
    static var postId: String { return "_id" }
    static var title: String { return "title" }
    static var requesterId: String { return "requesterId" }
    static var delivererId: String { return "delivererId" }
    static var location: String { return "location" }
    static var storeName: String { return "storeName" }
    static var shippingPoint: String { return "shippingPoint" }
    static var itemList: String { return "itemList" }
    static var itemQty: String { return "itemQty" }
    static var tip: String { return "tip" }
    static var note: String { return "note" }
    static var status: String { return "status" }
}
