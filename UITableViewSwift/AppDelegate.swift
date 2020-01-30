//
//  AppDelegate.swift
//  UITableViewSwift
//
//  Created by Павел Нехорошкин on 23/01/2020.
//  Copyright © 2020 Павел Нехорошкин. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else {
            return false
        }
        let controller = ViewController()
        let navigationController = UINavigationController(rootViewController: controller)
        window.rootViewController = navigationController
        window.backgroundColor = UIColor.gray
        window.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

