//
//  AppDelegate.swift
//  NetworkDaily
//
//  Created by wtildestar on 21/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?
    
    var bgSessionCompletionHandler: (() -> ())?
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        // нужно будет сохранить захваченное значение из completionHandler
        // в блок completionHandler будет передаваться сообщение с идентификатором сессии вызывающее запуск приложения
        // при запуске приложения снова создается для фоновой загрузки данных которая авт связывается с текущей фоновой активностью
        bgSessionCompletionHandler = completionHandler
        
    }


}

