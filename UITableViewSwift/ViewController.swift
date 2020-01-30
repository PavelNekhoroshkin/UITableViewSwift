//
//  ViewController.swift
//  UITableViewSwift
//
//  Created by Павел Нехорошкин on 23/01/2020.
//  Copyright © 2020 Павел Нехорошкин. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    private lazy var spinner = {
        UIActivityIndicatorView(style: .white)
    }()
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return view
    }()
    private lazy var store : DataStore = {
        Store()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "pokeapi.co"
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        view.addSubview(tableView)
        view.addSubview(spinner)
        setupConstraints()
        getPokemonList()
    }
    
    private func setupConstraints()  {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
    }
    
    /// Получение данных и загрузка в пустое хранилище
    private func getPokemonList() {
        guard store.count ==  0  else {
            return
        }
        fetchList { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let content):
                let parser = PokemonParser()
                let names = parser.parse(content: content)
                names.forEach {
                    self?.store.addToStore(name: $0)
                }
                self?.updateList()
            }
        }
    }
    
    /// Инициировать запрос на загрузку JSON
    ///
    /// - Parameter completion: замыкание, выполняющее обработку загруженного JSON
    private func fetchList(_ completion: @escaping (Result<Data, DownloadError>) -> Void) {
        spinner.startAnimating()
        let downloadService = DownloadService()
        let completionHandler : (Data?, URLResponse?, Error?) -> Void = { data , response, error in
            
            if let error = error  {
                completion(.failure(.downloadError(error)))
                return
            }
           
            if data == nil  {
                completion(.failure(.unknown("Получен пустой ответ")))
                return
            }
            
            if let data = data {
                completion(.success(data))
                return
            }
            
            completion(.failure(.unknown("Ошибка загрузки")))

        }
        
        downloadService.downloadList(completionHandler: completionHandler)
    }
    
    private func updateList() {
        
        DispatchQueue.main.async(execute: { [weak self] in
            self?.spinner.stopAnimating()
            self?.tableView.isHidden = false
            self?.tableView.reloadData()
        })
    }
}

extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = store[indexPath.row]
        return cell
    }
   
    
}
