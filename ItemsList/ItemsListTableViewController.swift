//
//  ViewController.swift
//  ItemsList
//
//  Created by bogdan.cernea on 07/05/2020.
//  Copyright © 2020 bogdan.cernea. All rights reserved.
//

import UIKit

class ItemsListTableViewController: UITableViewController {
    
    let cellIdentifier = "ItemCell"
    var list = List(title: "", items: [Item]()) {
        didSet {
            self.tableView.reloadData()
        }
    }
    var getItemsTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        self.getItemsTask = DataManager.shared.getItems { [weak self] (result) in
            self?.getItemsTask = nil // reset task
            switch result {
            case .success(let list):
                self?.list = list
            case .failure(let err):
                //TODO: - show error
                print(err)
            }
        }
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemTableViewCell else {
            return .init()
        }
        cell.item = list.items[indexPath.row]
        return cell
        
    }

}

