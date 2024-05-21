//
//  UserModel.swift
//  iOS_Example
//
//  Created by SmartSense Consulting Solutions Pvt. Ltd. on 17/05/24.
//

import Foundation

public struct UserModel : Codable, Identifiable {
    public let id : Int
    public let name: String
    public let email : String
    public let phone : String
    public let address : String
}
