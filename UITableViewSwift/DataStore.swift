//
//  DataStore.swift
//  UITableViewSwift
//
//  Created by Павел Нехорошкин on 28/01/2020.
//  Copyright © 2020 Павел Нехорошкин. All rights reserved.
//

class DataStore {
    static private let treeSet = TreeSet()
    
    class func addToStore(name: String) {
        treeSet.addNode(name)
    }
    
    class func gelList() -> [String] {
       return treeSet.toArray()
    }
    
    class func isEmpty() -> Bool {
        return treeSet.count == 0
    }
}
