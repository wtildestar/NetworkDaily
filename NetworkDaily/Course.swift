//
//  Course.swift
//  NetworkDaily
//
//  Created by wtildestar on 21/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import Foundation

/*
struct Course: Decodable {
    
    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
    let numberOfLessons: Int?
    let numberOfTests: Int?
    
}
 */

struct Course: Decodable {
    
    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
    let numberOfLessons: String?
    let numberOfTests: String?
    
    init?(json: [String: Any]) {
        
        let id = json["id"] as? Int
        let name = json["name"] as? String
        let link = json["link"] as? String
        let imageUrl = json["imageUrl"] as? String
        let numberOfLessons = json["numberOfLessons"] as? String
        let numberOfTests = json["numberOfLessons"] as? String
        
        self.id = id
        self.name = name
        self.link = link
        self.imageUrl = imageUrl
        self.numberOfLessons = numberOfLessons
        self.numberOfTests = numberOfTests
        
    }
    
    // добавим метод обработки массива
    static func getArray(from jsonArray: Any) -> [Course]? {
        guard let jsonArray = jsonArray as? Array<[String: Any]> else { return nil }
        return jsonArray.compactMap { Course(json: $0) }
//        var courses: [Course] = []
//
//        for jsonObject in jsonArray {
//
//            if let course = Course(json: jsonObject) {
//                courses.append(course)
//            }
//        }
//        return courses
    }
    
}
