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
    public let post: Post?
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
        
        let post  = (data["orderInfo"] as? [String: Any]).flatMap(Post.init)
        let requester = (data["requester"] as? [String: Any]).flatMap(User.init)
        
        self.init(
            post: post,
            requester: requester)
    }
    
    public init(
        post: Post? = nil,
        requester: User? = nil)
    {
        self.post = post
        self.requester = requester
    }
}
