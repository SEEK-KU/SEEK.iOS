//
//  LoginResponse.swift
//  Entity
//
//  Created by oatThanut on 15/4/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Foundation

public struct LoginResponse: DictionaryDecodableType, Codable, Equatable
{
    public let userToken: String?
    public let havetoSignup: Bool?
    
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
        
        let userToken = data["token"] as? String
        let havetoSignup = data["havetoSignup"] as? Bool
        
        self.init(
            userToken: userToken,
            havetoSignup: havetoSignup)
    }
    
    public init(
        userToken: String? = nil,
        havetoSignup: Bool? = nil )
    {
        self.userToken = userToken
        self.havetoSignup = havetoSignup
    }
}
