//
//  Ineractor.swift
//  SEEK
//
//  Created by oatThanut on 23/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Moya
import Foundation

public enum Interactor
{
    case feeds
    case order
}

extension Interactor: TargetType
{
    public var baseURL: URL
    {
        return URL(string: "https://private-029336-seek3.apiary-mock.com")!
    }
    
    public var path: String
    {
        switch self
        {
            case .feeds: return "/feeds"
            case .order: return "/order"
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
