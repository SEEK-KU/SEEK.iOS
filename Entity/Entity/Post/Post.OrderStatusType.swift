//
//  Post.OrderStatusType.swift
//  Entity
//
//  Created by oatThanut on 10/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Foundation

extension Post
{
    public enum OrderStatusType: String, Codable, CaseIterable
    {
        case active = "ACTIVE"
        case updatePrice = "PENDING_UPDATEPRICE"
        case confirmPrice = "PENDING_CONFIRMPRICE"
        case accepted = "ACCEPTED"
        case processing = "PROCESSING"
        case shipping = "SHIPPING"
        case completed = "COMPLETED"
        
        public init?(rawValue: String)
        {
            if rawValue.isEmpty
            {
                return nil
            }
            
            if rawValue.uppercased() == OrderStatusType.active.rawValue
            {
                self = .active
            }
            else if rawValue.uppercased() == OrderStatusType.updatePrice.rawValue
            {
                self = .updatePrice
            }
            else if rawValue.uppercased() == OrderStatusType.confirmPrice.rawValue
            {
                self = .confirmPrice
            }
            else if rawValue.uppercased() == OrderStatusType.accepted.rawValue
            {
                self = .accepted
            }
            else if rawValue.uppercased() == OrderStatusType.processing.rawValue
            {
                self = .processing
            }
            else if rawValue.uppercased() == OrderStatusType.shipping.rawValue
            {
                self = .shipping
            }
            else if rawValue.uppercased() == OrderStatusType.completed.rawValue
            {
                self = .completed
            }
            else
            {
                return nil
            }
        }
    }
}
