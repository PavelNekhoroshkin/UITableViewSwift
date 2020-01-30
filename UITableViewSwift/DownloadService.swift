//
//  DownloadService.swift
//  UITableViewSwift
//
//  Created by Павел Нехорошкин on 28/01/2020.
//  Copyright © 2020 Павел Нехорошкин. All rights reserved.
//

import Foundation

/// Ошибки загрузки
///
/// - downloadError: ошибка загрузки, содержит Error c описанием.
/// - unknown: данные не были получены, но описание ошибки отсутствует
enum DownloadError : Error {
    case downloadError(Error)
    case unknown(String)
}

/// Класс для загрузи данных
final class DownloadService  {
    
    private let url = "https://pokeapi.co/api/v2/pokemon?limit=1500"
    
    /// Выполнить запрос по url
    ///
    /// - Parameter completionHandler: замыкание, вызываемое в background после завершения загрузки
    func downloadList(completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        guard let url = URL(string: url) else {
            return
        }
        
        let task = session.dataTask(with: url, completionHandler: completionHandler)
        
        task.resume()
    }
    
}
