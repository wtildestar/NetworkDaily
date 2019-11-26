//
//  WebsiteDescription.swift
//  NetworkDaily
//
//  Created by wtildestar on 21/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import Foundation

struct WebsiteDescription: Decodable {
    
    let websiteDescription: String?
    let websiteName: String?
    let courses: [Course]
    
}
