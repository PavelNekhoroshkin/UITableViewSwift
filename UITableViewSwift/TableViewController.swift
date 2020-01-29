//
//  TableViewController.swift
//  UITableViewSwift
//
//  Created by Павел Нехорошкин on 29/01/2020.
//  Copyright © 2020 Павел Нехорошкин. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var pokemonList : [String]
    
    init(pokemons: [String]) {
        pokemonList = pokemons
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            assertionFailure("Не удалось создать ячейку для таблицы")
            return UITableViewCell()
        }
        
        if let textLabel = cell.textLabel {
            textLabel.text = pokemonList[indexPath.row]
        }
        
        return cell
    }
}
