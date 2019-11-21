//
//  MainViewController.swift
//  NetworkDaily
//
//  Created by wtildestar on 21/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBAction func getRequest(_ sender: Any) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            guard
                let response = response,
                let data = data
                else { return }
            print(response)
            print(data)
            
            // преобразуем в универсальный json формат с помощью сериализации
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        }.resume()
    }
    @IBAction func postRequest(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}
