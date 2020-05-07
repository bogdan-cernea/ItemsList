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
            self.title = list.title
            self.tableView.reloadData()
        }
    }
    var getItemsTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        self.tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        self.refreshControl?.beginRefreshing()
        self.loadItems()
        
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        self.loadItems()
        
    }
    
    private func loadItems() {
        self.list = List(title: "", items: [Item]())
        self.getItemsTask?.cancel()
        self.getItemsTask = DataManager.shared.getItems { [weak self] (result) in
            self?.getItemsTask = nil // reset task
            self?.refreshControl?.endRefreshing()
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
        cell.imageDownloadCompletion = { cell in
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        cell.item = list.items[indexPath.row]
        return cell
        
    }

}

