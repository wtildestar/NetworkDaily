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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
        
    }
    
    func fetchData() {
//        let jsonUrlString = "https://swiftbook.ru/wp-content/uploads/api/api_course"
        let jsonUrlString = "https://swiftbook.ru/wp-content/uploads/api/api_courses"
//        let jsonUrlString = "https://swiftbook.ru/wp-content/uploads/api/api_website_description"
//        let jsonUrlString = "https://swiftbook.ru/wp-content/uploads/api/api_missing_or_wrong_fields"
        
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            // декодируем данные по представлению из модели
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                self.courses = try decoder.decode([Course].self, from: data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print("Error serialization json", error)
            }
        }.resume()
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
        
        // открываем WebKitViewController кликая по ячейке
        performSegue(withIdentifier: "Description", sender: self)
    }
    
}

