//
//  UserModel.swift
//  SimpleChatApp
//
//  Created by Student on 01.02.21.
//

import Foundation

class UserModel {
    
    var uid: String?
    var username: String?
    var email: String?
    var profilImageUrl: String?
    
    init(dictionary: [String: Any]) {
        username = dictionary["username"] as? String
        email = dictionary["email"] as? String
        profilImageUrl = dictionary["profilImageURL"] as? String
        uid = dictionary["uid"] as? String
    }
    
}
