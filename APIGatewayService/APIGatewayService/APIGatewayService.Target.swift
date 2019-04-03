//
//  APIGatewayService.Target.swift
//  APIGatewayService
//
//  Created by oatThanut on 23/2/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity
import Foundation
import Moya

extension APIGatewayService
{
    public enum Target
    {
        case feeds
        case order(orderId: String)
        case user(userId: String)
        case createOrder(order: Post)
    }
}

extension APIGatewayService.Target: TargetType
{
    public var baseURL: URL
    {
        
        // MARK: - Mock
//        return URL(string: "https://private-029336-seek3.apiary-mock.com")!
        
        // MARK: - LocalHost
//        return URL(string: "http://localhost:3000")!
        
        // MARK: - Prod
            return URL(string: "http://158.108.34.104:3000")!
    }
    
    public var path: String
    {
        switch self
        {
            case .feeds: return "/feed"
            case .order(let orderId): return "/order/\(orderId)"
            case .user(let userId): return "/user/\(userId)"
            case .createOrder: return "/order"
        }
    }
    
    public var method: Moya.Method
    {
        switch self
        {
            case .feeds,
                 .order,
                 .user: return .get
            case .createOrder: return .post
        }
    }
    
    public var sampleData: Data
    {
        return Data()
    }
    
    public var task: Task
    {
        switch self
        {
            case .feeds,
                 .order,
                 .user: return .requestPlain
            
            case .createOrder(let order): return .requestJSONEncodable(order)
        }
    }
    
    public var headers: [String : String]?
    {
        return nil
    }
}
