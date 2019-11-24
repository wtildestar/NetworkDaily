//
//  AlamofireNetworkRequest.swift
//  NetworkDaily
//
//  Created by wtildestar on 24/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {
    
    static func sendRequest(url: String) {
        
        guard let url = URL(string: url) else { return }
        request(url, method: .get).responseJSON { (response) in
            print(response)
            
            
        }
    }
    
}
