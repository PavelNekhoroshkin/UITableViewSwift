//
//  PokemonParser.swift
//  UITableViewSwift
//
//  Created by Павел Нехорошкин on 30/01/2020.
//  Copyright © 2020 Павел Нехорошкин. All rights reserved.
//

import Foundation

/// Класс для разбора JSON c именами
class PokemonParser {
    
    /// Выполнить разбор JSON
    ///
    /// - Parameter content: данные для разбора
    /// - Returns: масссив с именами для отображения в интерфейсе
    func parse(content: Data) -> [String] {
        guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
            print("Не удалось обработать JSON")
            return []
        }
        guard let array = (json["results"] as? [[String : String]]) else {
            return []
            
        }
        return array.map { item in
            item["name"] ?? "unnamed"
        }
        
    }
}
