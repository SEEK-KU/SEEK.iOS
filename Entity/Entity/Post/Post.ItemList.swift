//
//  Post.ItemList.swift
//  Entity
//
//  Created by oatThanut on 2/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Foundation

extension Post
{
    public struct ItemList: DictionaryDecodableType, Codable, Hashable
    {
        public let name: String?
        public let price: Double?
        public let qty: Int?
        public let check: Bool?
        
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
            
            let name = data["name"] as? String
            let price = data["price"] as? Double
            let qty = data["qty"] as? Int
            let check = data["check"] as? Bool
            
            self.init(
                name: name,
                price: price,
                qty: qty,
                check: check)
        }
        
        public init(
            name: String? = nil,
            price: Double? = nil,
            qty: Int? = nil,
            check: Bool? = false)
        {
            self.name = name
            self.price = price
            self.qty = qty
            self.check = check
        }
    }
}
