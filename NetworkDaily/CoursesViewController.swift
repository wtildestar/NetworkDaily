//
//  CoursesViewController.swift
//  NetworkDaily
//
//  Created by wtildestar on 21/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit

class CoursesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
    }
    
    func fetchData() {
        
//        let jsonUrlString = "https://swiftbook.ru/wp-content/uploads/api/api_course"
//        let jsonUrlString = "https://swiftbook.ru/wp-content/uploads/api/api_courses"
//        let jsonUrlString = "https://swiftbook.ru/wp-content/uploads/api/api_website_description"
        let jsonUrlString = "https://swiftbook.ru/wp-content/uploads/api/api_missing_or_wrong_fields"
        
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            // декодируем данные по представлению из модели
            do {
                let websiteDescription = try JSONDecoder().decode(WebsiteDescription.self, from: data)
                print("\(websiteDescription.websiteName ?? "") \(websiteDescription.websiteDescription ?? "")")
            } catch let error {
                print("Error serialization json", error)
            }
            
            
        }.resume()
        
    }

}
