//
//  AppDelegate.swift
//  NetworkDaily
//
//  Created by wtildestar on 21/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?
    
    var bgSessionCompletionHandler: (() -> ())?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let appId = Settings.appID
        
        if url.scheme != nil && (url.scheme?.hasPrefix("fb\(String(describing: appId))"))! && url.host == "authorize" {
            return ApplicationDelegate.shared.application(app, open: url, options: options)
        }
        
        return false
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        // нужно будет сохранить захваченное значение из completionHandler
        // в блок completionHandler будет передаваться сообщение с идентификатором сессии вызывающее запуск приложения
        // при запуске приложения снова создается для фоновой загрузки данных которая авт связывается с текущей фоновой активностью
        bgSessionCompletionHandler = completionHandler
        
    }


}

