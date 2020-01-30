//
//  DataStore.swift
//  UITableViewSwift
//
//  Created by Павел Нехорошкин on 28/01/2020.
//  Copyright © 2020 Павел Нехорошкин. All rights reserved.
//

/// Протокол для хранения данных
protocol DataStore: AnyObject {
    var count : Int { get }
    subscript (_ index: Int) -> String { get }
    func addToStore(name: String)
}

/// Класс для хранения данных
final class Store : DataStore {
    
    private let treeSet = TreeSet()
    private lazy var arrayStore : [String] = {
        treeSet.toArray()
    }()
    private func gelList() -> [String] {
        return treeSet.toArray()
    }
    
    /// количество записей в хранилище
    var count : Int {
        arrayStore = treeSet.toArray()
        return arrayStore.count
    }
    
    /// Возращает запись по индексу
    ///
    /// - Parameter index: индекс
    subscript (_ index: Int) -> String {
        return arrayStore[index]
    }
    
    func addToStore(name: String) {
        treeSet.addNode(name)
    }
    
}
