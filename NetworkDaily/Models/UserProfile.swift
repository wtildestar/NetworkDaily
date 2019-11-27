//
//  UserProfile.swift
//  NetworkDaily
//
//  Created by wtildestar on 27/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import Foundation

struct UserProfile {
    
    let id: Int?
    let name: String?
    let email: String?
    
    
    // с помощью данного инициализатора распарсим словарь полученный при запросе данных пользователя
    init(data: [String: Any]) {
        let id = data["id"] as? Int
        let name = data["name"] as? String
        let email = data["email"] as? String
        
        self.id = id
        self.name = name
        self.email = email
    }
    
}


