//
//  APIGatewayService.Target.swift
//  APIGatewayService
//
//  Created by oatThanut on 23/2/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Foundation
import Moya

extension APIGatewayService
{
    public enum Target
    {
        case feeds
        case order(orderId: String)
    }
}

extension APIGatewayService.Target: TargetType
{
    public var baseURL: URL
    {
        return URL(string: "https://private-029336-seek3.apiary-mock.com")!
        //        return URL(string: "http://localhost:3000")!
    }
    
    public var path: String
    {
        switch self
        {
        case .feeds: return "/feeds"
        case .order(let orderId): return "/order/info/\(orderId)"
        }
    }
    
    public var method: Moya.Method
    {
        switch self
        {
        case .feeds: return .get
        case .order: return .get
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
        case .feeds: return .requestPlain
        case .order: return .requestPlain
        }
    }
    
    public var headers: [String : String]?
    {
        return nil
    }
}
