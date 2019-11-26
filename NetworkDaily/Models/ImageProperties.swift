//
//  ImageProperties.swift
//  NetworkDaily
//
//  Created by wtildestar on 23/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit

struct ImageProperties {
    
    let key: String
    let data: Data
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        guard let data = image.pngData() else { return nil }
        self.data = data
    }
    
}
