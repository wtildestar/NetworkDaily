//
//  CoursesViewController.swift
//  NetworkDaily
//
//  Created by wtildestar on 21/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit

class CoursesViewController: UIViewController {
    
    private var courses = [Course]()
    private var courseName: String?
    private var courseURL: String?
    private let url = "https://swiftbook.ru/wp-content/uploads/api/api_courses"
    private let postRequestUrl = "https://jsonplaceholder.typicode.com/posts"
    private let putRequestUrl = "https://jsonplaceholder.typicode.com/posts/1"
    
    @IBOutlet weak var tableView: UITableView!
    
    func fetchData() {
        
        NetworkManager.fetchData(url: url) { (courses) in
            // передаем массив courses с NetworkManager
            self.courses = courses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    func fetchDataWithAlamofire() {
        AlamofireNetworkRequest.sendRequest(url: url) { (courses) in
            self.courses = courses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func postRequest() {
        AlamofireNetworkRequest.postRequest(url: postRequestUrl) { (courses) in
            self.courses = courses
            // делаем обновление интерфейса в основном потоке
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func putRequest() {
        AlamofireNetworkRequest.putRequest(url: putRequestUrl) { (courses) in
            self.courses = courses
            
            DispatchQueue.main.async {
               self.tableView.reloadData()
           }
        }
    }
    
    // создаем метод для конфигурации ячейки
    private func configureCell(cell: TableViewCell, for indexPath: IndexPath) {
        let course = courses[indexPath.row]
        cell.courseNameLabel.text = course.name
        
        if let numberOfLessons = course.numberOfLessons {
            cell.numberOfLessons.text = "Number of lessons: \(numberOfLessons)"
        }
        
        if let numberOfTests = course.numberOfTests {
            cell.numberOfTests.text = "Number of tests: \(numberOfTests)"
        }
        
        // работу по получению данных пишем в глобальной очереди
        DispatchQueue.global().async {
            // берем изображение по ссылке
            guard let imageUrl = URL(string: course.imageUrl!) else { return }
            // проверяем есть ли данные по ссылке
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            // внутри глобальной очереди обращаемся к основной очереди
            DispatchQueue.main.async {
                // присваиваем данные ячейке
                cell.courseImage.image = UIImage(data: imageData)
            }
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webKitViewController = segue.destination as! WebKitViewController
        webKitViewController.navigationTitle.title = courseName
        
        if let url = courseURL {
            webKitViewController.courseURL = url
        }
    }
}

// MARK: DataSource

extension CoursesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        
        configureCell(cell: cell, for: indexPath)
        
        return cell
        
    }
    
}

// MARK: Table View Delegate

extension CoursesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = courses[indexPath.row]
        
        // передаем данные ссылки и имени в приватные переменные по клику на ячейку
        courseURL = course.link
        courseName = course.name
        
        //         открываем WebKitViewController кликая по ячейке
        performSegue(withIdentifier: "Description", sender: self)
    }
    
}

