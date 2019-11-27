//
//  CurrentUser.swift
//  NetworkDaily
//
//  Created by wtildestar on 28/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import Foundation

struct CurrentUser {
    let uid: String
    let name: String
    let email: String
    
    init?(uid: String, data: [String: Any]) {
        guard
            let name = data["name"] as? String,
            let email = data["email"] as? String
            else { return nil }
        
        self.uid = uid
        self.name = name
        self.email = email
    }
}
