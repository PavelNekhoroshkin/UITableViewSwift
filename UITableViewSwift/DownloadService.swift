//
//  DownloadService.swift
//  UITableViewSwift
//
//  Created by Павел Нехорошкин on 28/01/2020.
//  Copyright © 2020 Павел Нехорошкин. All rights reserved.
//

import Foundation

class DownloadService  {
    
    let viewController : ViewController
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
    
    func downloadList() {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=1500") else {
            return
        }
        let task = session.dataTask(with: url) { data, response, error in
            
            guard error == nil, let content = data  else {
                print ("ERROR: \(error!)")
                return
            }
            
            guard data != nil else {
                print("Нет данных")
                return
            }
            
            switch content.count % 10 {
                case 2, 3, 4 :
                     print("Загружено \(content.count) байта")
                default :
                     print("Загружено \(content.count) байт")
            }
            
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("JSON не распознан")
                return
            }

            guard let array = (json["results"] as? Array<Dictionary<String, String>>) else {
                return
            }
            
            switch array.count % 10 {
                case 1 :
                    print("Найдено \(array.count) имя")
                case 2, 3, 4 :
                    print("Найдено \(array.count) имени")
                default :
                    print("Найдено \(array.count) имен")
            }
           
            for item in array {
                if let name = item["name"] {
                    DataStore.addToStore(name: name)
                }
            }
            
            DispatchQueue.main.async(execute: {
                self.viewController.button.setTitle("ПОКАЗАТЬ СПИСОК", for: .normal)
                self.viewController.showTableView()
            })
        }
        task.resume()
    }
    
}
