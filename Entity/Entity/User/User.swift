//
//  User.swift
//  Entity
//
//  Created by oatThanut on 31/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Foundation

public struct User: DictionaryDecodableType, Codable, Equatable
{
    public let userId: String?
    public let firstname: String?
    public let lastname: String?
    public let faculty: String?
    public let telphone: String?
    public let image: String?
    public let qrImage: String?
    
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
        
        let userId = data[.userId] as? String
        let firstname = data[.firstname] as? String
        let lastname = data[.lastname] as? String
        let faculty = data[.faculty] as? String
        let telphone = data[.telphone] as? String
        let image = data[.image] as? String
        let qrImage = data[.qrImage] as? String
        
        self.init(
            userId: userId,
            firstname: firstname,
            lastname: lastname,
            faculty: faculty,
            telphone: telphone,
            image: image,
            qrImage: qrImage)
    }
    
    public init(
        userId: String? = nil,
        firstname: String? = nil,
        lastname: String? = nil,
        faculty: String? = nil,
        telphone: String? = nil,
        image: String? = nil,
        qrImage: String? = nil)
    {
        self.userId = userId
        self.firstname = firstname
        self.lastname = lastname
        self.faculty = faculty
        self.telphone = telphone
        self.image = image
        self.qrImage = qrImage
    }
}

extension String
{
    static var userId: String { return "stdId" }
    static var firstname: String { return "firstname" }
    static var lastname: String { return "lastname" }
    static var faculty: String { return "faculty" }
    static var telphone: String { return "telephone" }
    static var image: String { return "img" }
    static var qrImage: String { return "qrImage" }
}
