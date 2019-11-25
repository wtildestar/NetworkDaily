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
    
    static func sendRequest(url: String, completion: @escaping (_ courses: [Course]) -> ()) {
        
        guard let url = URL(string: url) else { return }
        request(url, method: .get).validate().responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                
                var courses = [Course]()
                courses = Course.getArray(from: value)!
                completion(courses)
                
            case.failure(let error):
                print(error)
            }
            
        }
    }
    
    static func responseData(url: String) {
        request(url).responseData { (responseData) in
            switch responseData.result {
            case .success(let data):
                guard let string = String(data: data, encoding: .utf8) else { return }
                print(string)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func responseString(url: String) {
        request(url).responseString { (responseString) in
            switch responseString.result {
            case .success(let string):
                print(string)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // у метода response нет result, то есть полученные данные обрабатываются вручную
    static func response(url: String) {
        request(url).responseData { (response) in
            guard
                let data = response.data,
                let string = String(data: data, encoding: .utf8)
                else { return }
            
            print(string)
        }
    }
    
}
