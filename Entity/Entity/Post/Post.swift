//
//  Post.swift
//  Entity
//
//  Created by oatThanut on 26/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Foundation

public struct Post: DictionaryDecodableType, Codable, Equatable
{
    public let postId: String?
    public let title: String?
    public let location: String?
    public let destination: String?
    public let note: String?
    public let storeName: String?
    public let status: String?
    public let tip: Double?
    
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
        let location = data[.location] as? String
        let destination = data[.destination] as? String
        let note = data[.note] as? String
        let storeName = data[.storeName] as? String
        let status = data[.status] as? String
        let tip = data[.tip] as? Double
        
        self.init(
            postId: postId,
            title: title,
            location: location,
            destination: destination,
            note: note,
            storeName: storeName,
            status: status,
            tip: tip)
    }
    
    public init(
        postId: String? = nil,
        title: String? = nil,
        location: String? = nil,
        destination: String? = nil,
        note: String? = nil,
        storeName: String? = nil,
        status: String? = nil,
        tip: Double? = nil)
    {
        self.postId = postId
        self.title = title
        self.location = location
        self.destination = destination
        self.note = note
        self.storeName = storeName
        self.status = status
        self.tip = tip
    }
}

extension String
{
    static var postId: String { return "postId" }
    static var title: String { return "title" }
    static var location: String { return "location" }
    static var destination: String { return "shippingPoint" }
    static var note: String { return "note" }
    static var storeName: String { return "storeName" }
    static var status: String { return "status" }
    static var tip: String { return "tip" }
}
