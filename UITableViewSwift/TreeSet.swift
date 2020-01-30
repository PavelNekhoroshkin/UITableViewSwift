//
//  TreeSet.swift
//  UITableViewSwift
//
//  Created by Павел Нехорошкин on 28/01/2020.
//  Copyright © 2020 Павел Нехорошкин. All rights reserved.
//

//import Foundation

/// Красно-черное дерево String
final class TreeSet : IteratorProtocol {
    func next() -> String? {
       return getNext()?.value
    }
    
    typealias Element = String
    
    private var root: Entry?
    var count = 0
    private var pointer : Entry?
    
    private func getNext() -> Entry? {
        
        guard let root = root else {
            return nil
        }
        // начало обхода дерева с самого левого узла
        guard let curent = pointer else {
            pointer = root
            while let left = pointer?.left {
                    pointer = left
            }
            return pointer
        }
        //продолжение обхода дерева, есть правый узел
        if let curent = curent.right {
            pointer = curent
            while let left = pointer?.left  {
                pointer = left
            }
            return pointer
        }
        //продолжение обхода дерева, правого узла нет 
        if curent.isLeft {
            pointer = curent.parent
            return pointer
        }
        
        while let parent = pointer?.parent {
            pointer = parent
            if parent.isLeft {
                pointer = pointer?.parent
                return pointer
            }
        }
        
        pointer = nil
        return pointer
    }
    
    /// Высота не пустого дерева это максимум высот левой и правой ветви  плюс 1
    var height : Int {
        guard let node = root else { return 0 } // высота пустого дерева
        var heightRight = 1
        if let right = node.right {
            heightRight += right.height
        }
        var heightLeft = 1
        if let left = node.left {
            heightLeft += left.height
        }
        return heightRight >= heightLeft ? heightRight : heightLeft
    }
    
    private class Entry {
        var parent : Entry?
        var value : String
        var isRed = false
        var isLeft = false
        var left : Entry?
        var right: Entry?
        
        init(_ val: String) {
            value = val
        }
        //измеряем рекрсивном высоту до листьев в правой и левой ветвях
        fileprivate var height : Int {
            var heightRight = 1
            if let right = right {
                heightRight += right.height
            }
            var heightLeft = 1
            if let left = left {
                heightLeft += left.height
            }
            return heightRight >= heightLeft ? heightRight : heightLeft
        }
        //получить деда узла
        fileprivate var grandparent : Entry? {
            return parent?.parent
        }
    }
    
    // получить дядю узла
    private func uncle(_ node: Entry) -> Entry? {
        guard let grandparent = node.grandparent else { return nil }
        //если у деда есть левый узел и он совпадает с родителем текущего
        if  grandparent.left === node.parent {
            // значит дядя - правый узел деда
            return grandparent.right
        } else {
            //иначе дядя, это левый узел деда
            return  grandparent.left
        }
    }
    
    private func insertCase1(_ node: Entry) {
        guard let parent = node.parent else {
            //родителя нет, значит изменения в корне, делаем корень черным
            node.isRed = false
            return
        }
        //если изменения НЕ в корне, проверим родителя
        if parent.isRed == false {
            //родитель черный, дерево валидно, дальше не проверяем
            return
        } else {
            //иначе переходим к рассмотрению случая 2
            insertCase2(node)
        }
    }
    
    private func insertCase2(_ node: Entry) {
        //случай, когда родитель красный (и узел тоже красный, т.е. сбалансированность нарушена)
        guard let uncle = uncle(node) else {
            insertCase3(node)
            return
        }
        guard uncle.isRed else {
            insertCase3(node)
            return
        }
        // если дядя есть и он тоже красный
        // перекрасим узлы выше в черный
        if let parent = node.parent  {
            parent.isRed = false
        }
        uncle.isRed = false
        //если есть дядя, то есть и дед
        if let grandparent = node.grandparent {
            //чтобы сохранить черую высоту дерева перекрашиваем деда в красный
            grandparent.isRed = true
            //и перейдем к проверке валидности дерева на уровне деда начиная с рассмотрения случая 1
            insertCase1(grandparent)
        }
    }
    
    private func insertCase3(_ node: Entry) {
        //случай, когда дяди нет, или он черный, возможно потребуется дополнительный поворот
        guard let parent = node.parent else {
            return
        }
        // если поворот не понадобится, то следующий шаг выполняется для самого узла
        var newNode =  node
        // при необходимости сделаем дополнительный поворот, тогда узлом для следующего шага назначим старого родителя добавленного узла
        if let grandparent = node.grandparent {
            // дополнительный поворот делаем только когда сторона, куда добавлен новый узел, не совпадает со стороной, где был родитель от деда, поворот должен сделать так, чтобы и родитель и новый узел были с одной стороны
            if node === parent.right, node.parent === grandparent.left {
                rotateLeft(node)
                newNode = parent
            }
            else if node === parent.left, node.parent === grandparent.right {
                rotateRight(node)
                newNode = parent
            }
        }
        insertCase4(newNode)
    }
    
    private func insertCase4(_ node:Entry) {
        // когда  новый узел (красный) и его  родитель (красный) находятся с одной и той же стороны нужно выполнить сдвиг, чтобы устранить проблему двух красных узлов
        guard let parent = node.parent else {
            return
        }
        //перекрасим родителя
        parent.isRed = false
        guard let grandparent = node.grandparent else {
            //поворот вокруг корня
            if node === parent.right {
                rotateLeft(parent)
            } else  {
                rotateRight(parent)
            }
            return
        }
        grandparent.isRed = true
        if node === parent.right, parent === grandparent.right {
            rotateLeft(parent)
        } else if node === parent.left, parent === grandparent.left {
            rotateRight(parent)
        }
    }
    
    private func rotateLeft(_ node: Entry) {
        guard let parent = node.parent else {
            return
        }
        // левую ветку переносим в правую ветку родителя
        parent.right = node.left
        if let right = parent.right {
            right.parent = parent
        }
        //переносим ноду на место родителя (к деду, или в корень, когда деда нет)
        if let grandparent = parent.parent {
            node.parent = grandparent
            if grandparent.left === parent {
                grandparent.left = node
            } else {
                grandparent.right = node
            }
        } else {
            //если родитель был в корне, то вместо него сейчас в корне станет узел
            if root === parent {
                root = node
                node.parent = nil
            }
        }
        node.left = parent
        parent.parent = node
    }
    
    private func rotateRight(_ node: Entry) {
        guard let parent = node.parent else {
            return
        }
        //правую ветку переносим в левую ветку родителя
        parent.left = node.right
        if let left = parent.left  {
            left.parent = parent
        }
        //переносим ноду на место родителя (к деду, или в корень, когда деда нет)
        if let grandparent = parent.parent {
            node.parent = grandparent
            if grandparent.left === parent {
                grandparent.left = node
            } else {
                grandparent.right = node
            }
        } else {
            //если родитель был в корне, то вместо него сейчас в корне станет узел
            if root === parent {
                root = node
                node.parent = nil
            }
        }
        node.right = parent
        parent.parent = node      //прописываем обратную связь
    }
    
    /// Добавление узла
    ///
    /// - Parameter val: значение для хранения в узле
    func addNode(_ val : String) {
        let newEntry = Entry(val)
        guard let root = root  else {
            self.root = newEntry
            count = 1
            return
        }
        newEntry.isRed = true
        // ищем место для новго значения, находим подходящий лист
        
        var parent = root
        var nextEntry: Entry? = root
        
        while let existedEntry = nextEntry {
            parent = existedEntry
            if newEntry.value == existedEntry.value {
                //узел уже есть
                return
            } else if newEntry.value > existedEntry.value {
                nextEntry = existedEntry.right
            } else {
                nextEntry = existedEntry.left
            }
        }
       
        //дошли до листа (nil), добавляем новую запись
        newEntry.parent = parent
        if newEntry.value > parent.value {
            parent.right = newEntry
        } else {
            parent.left = newEntry
        }
        count += 1
        insertCase1(newEntry)
    }
    
    /// Печатает полную структуру дерева
    func printTree() {
        guard let node = root else {
            print("nil")
            return
        }
        let numberOfRows = 1 << height
        var matrix = [[String]]()
        matrix.append([String](repeating: "", count: numberOfRows))
        parseNodeForPrint(numberOfRows, numberOfRows/4, 0, numberOfRows/2, node, &matrix)
        
        for i in 0...numberOfRows-1 {
            var string = ""
            for j in 0...matrix.count-1 {
                string += matrix[j][i] + "\t"
            }
            print(string)
        }
    }
    
    /// Рекурсивнно вызывается для каждого узла и заполняет массив данными левой и правой ветви текущего узла. После завершения массив будет содержать данные дерева с иерархией всех узлов, который затем может быть распечатан
    ///
    /// - Parameters:
    ///   - length: глубина от текущей ноды до листьев
    ///   - step: шаг по вертикалями между нодами одного уровня
    ///   - x: столбец массива, в котором записан текущий узел, определяется глубинрй иерархии узла от корня, начиная с нуля
    ///   - y: строка массива, на которой отображен текущий узел, его правые ветви идут вверх, левые - вниз
    ///   - node: текущий узел
    ///   - array: заполняемый массив
    private func parseNodeForPrint(_ length: Int, _ step: Int, _ x: Int, _ y: Int, _ node: Entry, _ array:inout [[String]]) {
        if x+1 == array.count {
            //столбцов должно хватать даже листьев, которые заполняются на этой итерации
            array.append([String](repeating: "", count: length))
        }
        array[x][y] = String(node.value)
        if let right = node.right {
            var i = 1
            while i < step {
                array[x][y-i] = "|"
                i = i+1
            }
            array[x][y-step] = " --"
            parseNodeForPrint(length, step/2, x+1, y-step, right, &array)
        }
        if let left = node.left {
            var i = 1
            while i < step+1 {
                array[x][y+i] = "|"
                i = i+1
            }
            array[x][y+step] = " --"
            parseNodeForPrint(length, step/2, x+1, y+step, left, &array)
        }
    }
    
    func toArray() -> [String] {
        guard let root = root else{
            return []
        }
        var array = [String]()
        parseNodeForArray(root, &array)
        return array
    }
    
    /// Рекурсивно вызывается для каждого узла, добавляя в переданный массив в порядке возрастания все его элементы и элементы его ветвей.
    ///
    /// - Parameters:
    ///   - node: добавляемый узел
    ///   - array: заполняемый массив
    private func parseNodeForArray(_ node:Entry, _ array:inout [String]) {
        if let left = node.left {
            parseNodeForArray(left, &array)
        }
        array.append(node.value)
        if let right = node.right {
            parseNodeForArray(right, &array)
        }
    }
}
