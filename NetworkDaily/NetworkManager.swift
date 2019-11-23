
//
//  NetworkManager.swift
//  NetworkDaily
//
//  Created by wtildestar on 23/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit

class NetworkManager {
    static func getRequest(url: String) {
        guard let url = URL(string: url) else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            guard
                
                let data = data
                else { return }
            
            // преобразуем в универсальный json формат с помощью сериализации
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    static func postRequest(url: String) {
        guard let url = URL(string: url) else { return }
        let userData = ["Course": "Netwoking", "Lesson": "GET and POST Request"]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else { return }
        // помещаем данные для отправки в тело запроса
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // создаем сессию для отправки данных на сервер
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    static func downloadImage(url: String, completion: @escaping (_ image: UIImage) -> ()) {
        // пишем проверку на валидность нашего адреса
        guard let url = URL(string: url) else { return }
        
        // если адрес будет валидным создаем экземпляр URLSession вызывая свойство класса shared создав singleton объекта для общей сессии который использует глобальный кеш для хранения файлов куки и учетных данных
        let session = URLSession.shared
        // создает задачу на получение содержимого по указанному урл-адресу
        session.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                // передаем задачу по обновлению интерфейса в основной поток
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }.resume()
    }
    
    static func fetchData(url: String, completion: @escaping (_ courses: [Course]) -> ()) {
        guard let url = URL(string: url) else { return }
               URLSession.shared.dataTask(with: url) { (data, _, _) in
                   guard let data = data else { return }
                   // декодируем данные по представлению из модели
                   do {
                       let decoder = JSONDecoder()
                       decoder.keyDecodingStrategy = .convertFromSnakeCase
                       let courses = try decoder.decode([Course].self, from: data)
                        completion(courses)
                   } catch let error {
                       print("Error serialization json", error)
                   }
               }.resume()
    }
}
