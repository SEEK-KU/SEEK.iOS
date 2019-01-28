//
//  Post.swift
//  SEEK
//
//  Created by oatThanut on 26/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Foundation

public struct Post: DictionaryDecodableType, Codable, Equatable
{
    public let title: String?
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
        
        let title = data[.title] as? String
        let tip = data[.tip] as? Double
        
        self.init(
            title: title,
            tip: tip)
    }
    
    public init(
        title: String? = nil,
        tip: Double? = nil)
    {
        self.title = title
        self.tip = tip
    }
}

extension String
{
    static var title: String { return "title" }
    static var tip: String { return "tip" }
}
