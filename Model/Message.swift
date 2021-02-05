//
//  Message.swift
//  SimpleChatApp
//
//  Created by Student on 01.02.21.
//

import UIKit
import FirebaseAuth

class Message {
    
    var text: String?
    var fromUserWithUID: String?
    var toUserWithUID: String?
    var timestamp: Int?
    
    func chatPartnerId() -> String? {
        if fromUserWithUID == Auth.auth().currentUser?.uid {
            return toUserWithUID
        } else {
            return fromUserWithUID
        }
    }
    
    
    init(dictionary: [String: Any]) {
        text = dictionary["message"] as? String
        fromUserWithUID = dictionary["fromUserWithUID"] as? String
        toUserWithUID = dictionary["toUserWithUID"] as? String
        timestamp = dictionary["timestamp"] as? Int
    }
}


//    let dicData: [String: Any] = ["message": message, "fromUserWithUID": fromUserWithUID, "toUserWithUID": toUserWithUID, "timestamp": timestamp ]

