//
//  ViewController.swift
//  NetworkDaily
//
//  Created by wtildestar on 21/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var getImageButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
           super.viewDidLoad()
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
       }
    
    @IBAction func getImagePressed(_ sender: Any) {
        label.isHidden = true
        getImageButton.isEnabled = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        // пишем проверку на валидность нашего адреса
        guard let url = URL(string: "http://papers.co/wallpaper/papers.co-bj16-sky-blue-pastel-art-1-wallpaper.jpg") else { return }
        
        // если адрес будет валидным создаем экземпляр URLSession вызывая свойство класса shared создав singleton объекта для общей сессии который использует глобальный кеш для хранения файлов куки и учетных данных
        let session = URLSession.shared
        // создает задачу на получение содержимого по указанному урл-адресу
        session.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                // передаем задачу по обновлению интерфейса в основной поток
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.imageView.image = image
                }
            }
        }.resume()
        
    }
}

