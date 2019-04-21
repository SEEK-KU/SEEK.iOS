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
        
        case user(userToken: String)
        
        case createOrder(
            token: String,
            order: Post)
        
        case updateOrder(
            orderId: String,
            orderDetail: PostDetail)
        
        case updateOrderStatus(
            orderId: String,
            orderStatus: Post.OrderStatusType)
        
        case login(
            userId: String,
            password: String)
        
        case signUp(
            token: String,
            firstname: String,
            lastname: String,
            faculty: String,
            telephone: String)
        
        case orderHistory(
            token: String,
            historyType: String)
        
        case updateProfilePicture(
            token: String,
            imageURL: String)
        
        case loadUserQR(token: String)
        
        case uploadUserQR(
            token: String,
            imageURL: String)
        
        case uploadSlip(
            orderId: String,
            slipURL: String)
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
            case .user: return "/user"
            case .createOrder: return "/order"
            case .updateOrder(let orderId, _): return "/order/\(orderId)"
            case .updateOrderStatus(let orderId, _): return "/order/\(orderId)"
            case .login: return "/login"
            case .signUp: return "/user"
            case .orderHistory: return "/user/history"
            case .updateProfilePicture: return "/user"
            case .loadUserQR: return "/getUserQR"
            case .uploadUserQR: return "/user"
            case .uploadSlip: return "/uploadSlip"
        }
    }
    
    public var method: Moya.Method
    {
        if case .feeds = self
        {
            return .get
        }
        else if case .order = self
        {
            return .get
        }
        else if case .user = self
        {
            return .get
        }
        else if case .createOrder = self
        {
            return .post
        }
        else if case .updateOrder = self
        {
            return .put
        }
        else if case .updateOrderStatus = self
        {
            return .put
        }
        else if case .login = self
        {
            return .post
        }
        else if case .signUp = self
        {
            return .put
        }
        else if case .orderHistory = self
        {
            return .get
        }
        else if case .updateProfilePicture = self
        {
            return .put
        }
        else if case .loadUserQR = self
        {
            return .get
        }
        else if case .uploadUserQR = self
        {
            return .put
        }
        else if case .uploadSlip = self
        {
            return .put
        }
        else
        {
            fatalError("Invalid Target")
        }
    }
    
    public var sampleData: Data
    {
        return Data()
    }
    
    public var task: Task
    {
        if case .feeds = self
        {
            return .requestPlain
        }
        else if case .order = self
        {
            return .requestPlain
        }
        else if case .user = self
        {
            return .requestPlain
        }
        else if case let .createOrder(_, order) = self
        {
            return .requestJSONEncodable(order)
        }
        else if case let .updateOrder( _, orderDetail) = self
        {
            return .requestJSONEncodable(orderDetail)
        }
        else if case let .updateOrderStatus( _, orderStatus) = self
        {
            var parameters: [String: Any] = [:]
            
            parameters["orderInfo"] = ["status": orderStatus.rawValue]
            
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default)
        }
        else if case let .login(userId, password) = self
        {
            var parameter: [String: Any] = [:]
            
            parameter["userId"] = userId
            parameter["password"] = password
            
            return .requestParameters(
                parameters: parameter,
                encoding: JSONEncoding.default)
        }
        else if case let .signUp(
            _,
            firstname,
            lastname,
            faculty,
            telephone) = self
        {
            var parameter: [String: Any] = [:]
            
            parameter["userInfo"] = [
                "firstname": firstname,
                "lastname": lastname,
                "faculty": faculty,
                "telephone": telephone ]
            
            return .requestParameters(
                parameters: parameter,
                encoding: JSONEncoding.default)
        }
        else if case .orderHistory = self
        {
            return .requestPlain
        }
        else if case let .updateProfilePicture(_, imageURL) = self
        {
            var parameter: [String: Any] = [:]
            parameter["userInfo"] = ["img": imageURL]
            
            return .requestParameters(
                parameters: parameter,
                encoding: JSONEncoding.default)
        }
        else if case .loadUserQR = self
        {
            return .requestPlain
        }
        else if case let .uploadUserQR(_, imageURL) = self
        {
            var parameter: [String: Any] = [:]
            
            parameter["userInfo"] = ["qrImage": imageURL]
            
            return .requestParameters(
                parameters: parameter,
                encoding: JSONEncoding.default)
        }
        else if case let .uploadSlip(orderId, slipURL) = self
        {
            var parameter: [String: Any] = [:]
            parameter["postId"] = orderId
            parameter["slip"] = slipURL
            
            return .requestParameters(
                parameters: parameter,
                encoding: JSONEncoding.default)
        }
        else
        {
            fatalError("Invalid Target")
        }
    }
    
    public var headers: [String : String]?
    {
        if case let .user(userToken) = self
        {
            return ["token": userToken]
        }
        else if case let .orderHistory(token, historyType) = self
        {
            return ["token": token,
                    "historyType": historyType]
        }
        else if case let .signUp(token, _, _, _, _) = self
        {
            return ["token": token]
        }
        else if case let .createOrder(token, _) = self
        {
            return ["token": token]
        }
        else if case let .updateProfilePicture(token, _) = self
        {
            return ["token": token]
        }
        else if case let .loadUserQR(token) = self
        {
            return ["token": token]
        }
        else if case let .uploadUserQR(token, _) = self
        {
            return ["token": token]
        }
        return nil
    }
}
