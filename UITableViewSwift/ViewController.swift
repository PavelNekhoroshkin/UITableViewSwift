//
//  ViewController.swift
//  UITableViewSwift
//
//  Created by Павел Нехорошкин on 23/01/2020.
//  Copyright © 2020 Павел Нехорошкин. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
    let button = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "pokeapi.co"
        
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("ЗАГРУЗИТЬ СПИСОК", for: .normal)
        button.addTarget(self, action: #selector(ViewController.getPokemonList), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false;
        spinner.translatesAutoresizingMaskIntoConstraints = false;
        view.addSubview(button)
        view.addSubview(spinner)
        view.addConstraints( generateConstraints() )
    }
    

   
    private func generateConstraints() -> [NSLayoutConstraint] {
       
        let constraintWidthButton = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200.0)
        let constraintHeightButton = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 80)
        let constraintTopButton = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 180)
        let constraintCenterXButton = NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0,constant: 0.0)
        let constraintCenterXSpinner = NSLayoutConstraint(item: spinner, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0,constant: 0.0)
        let constraintCenterYSpinner = NSLayoutConstraint(item: spinner, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0,constant: 0.0)
        
        return [constraintWidthButton, constraintHeightButton, constraintTopButton, constraintCenterXButton, constraintCenterXSpinner, constraintCenterYSpinner]
    }
    
    @objc func getPokemonList() {
        if DataStore.isEmpty() {
            downloadPokemonList()
        } else {
            showTableView()
        }
    }
    
    func downloadPokemonList() {
        spinner.startAnimating()
        let downloadService = DownloadService(viewController: self)
        downloadService.downloadList()
    }
    
    func showTableView() {
        spinner.stopAnimating()
        let pokemons = DataStore.gelList()
        let tableViewController = TableViewController(pokemons: pokemons)
        self.navigationController?.pushViewController(tableViewController, animated: true)
    }
    
}
