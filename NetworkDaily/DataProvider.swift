//
//  DataProvider.swift
//  NetworkDaily
//
//  Created by wtildestar on 23/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit

class DataProvider: NSObject {
    // объявим экземпляр  URLSession с типом URLSessionDownloadTask
    private var downloadTask: URLSessionDownloadTask!
    // захватывает текущий путь к файлу для делегата расширения
    var fileLocation: ((URL) -> ())?
    var onProgress: ((Double) -> ())?
    // настройка конфигурации сессии
    private lazy var bgSession: URLSession = {
        // свойство config будет определять поведение сессии при загрузке и выгрузки данных
        let config = URLSessionConfiguration.background(withIdentifier: "wtildestar.NetworkDaily")
        config.isDiscretionary = true // запуск задачи в оптимальное время (по умолч false)
        config.timeoutIntervalForResource = 300 // Время ожидания сети в сек
        config.waitsForConnectivity = true // Ожидание подключения к сети (по умолч true)
        // по завершению загрузки данных приложение запуститься в фоновом режиме
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    // метод по загрузке данных
    func startDownload() {
        if let url = URL(string: "https://speed.hetzner.de/100MB.bin") {
            // передаем в экземпляр URLSession все параметры конфигурации
            downloadTask = bgSession.downloadTask(with: url)
            // после инициализации сессии мы не можем вносить никаких изменений в параметры конфигурации
            downloadTask.earliestBeginDate = Date().addingTimeInterval(3) // задача начнется не ранее 3 сек
            downloadTask.countOfBytesClientExpectsToSend = 512 // верхняя граница числа байтов отправки
            downloadTask.countOfBytesClientExpectsToReceive = 100 * 1024 * 1024 // (100 мб) верхняя граница числа байтов получения
            downloadTask.resume()
        }
    }
    
    func stopDownload() {
        // отмена всех задач
        downloadTask.cancel()
    }
    
}

extension DataProvider: URLSessionDelegate {
    // вызывается по завершению всех фоновых задач
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        // теперь когда есть метод для сопоставления идентификаторов сессий можно вызывать его передав в блок идентификатор нашей сессии
        // bgSessionCompletionHandler относится к UIKit -  передаем все асинхронно
        DispatchQueue.main.async {
            guard
                let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let completionHandler = appDelegate.bgSessionCompletionHandler
                else { return }
            
            appDelegate.bgSessionCompletionHandler = nil
            // вызываем исх блок completionHandler чтобы уведомить что загрузка была завершена
            completionHandler()
        }
    }
}

// получаем ссылку на загруженный файл и отображаем ход загрузки данных
extension DataProvider: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Did finish downloading: \(location.absoluteString)")
        
        DispatchQueue.main.async {
            // сохраняем ссылку на временную директорию
            self.fileLocation?(location)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        // если ожидаемый размер для записи не равен - выходим из метода
        guard totalBytesWritten != NSURLSessionTransferSizeUnknown else { return }
        
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        print("download progress: \(progress)")
        // присвоим полученное значение onProgress
        DispatchQueue.main.async {
            self.onProgress?(progress)
        }
        
    }
    // восстановления соединения
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        
        // ожидание соединения, обновление интерфейса и прочее
        
    }
    
    
}
