//
//  PostDetail.swift
//  Entity
//
//  Created by oatThanut on 19/2/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Foundation

public struct PostDetail: DictionaryDecodableType, Codable, Equatable
{
    public let orderInfo: Post?
    public let requester: User?
    
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
        
        let orderInfo  = (data["orderInfo"] as? [String: Any]).flatMap(Post.init)
        let requester = (data["requester"] as? [String: Any]).flatMap(User.init)
        
        self.init(
            orderInfo: orderInfo,
            requester: requester)
    }
    
    public init(
        orderInfo: Post? = nil,
        requester: User? = nil)
    {
        self.orderInfo = orderInfo
        self.requester = requester
    }
}
