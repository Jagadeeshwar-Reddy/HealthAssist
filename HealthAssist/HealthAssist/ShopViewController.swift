//
//  ShopViewController.swift
//  HealthAssist
//
//  Created by Jagadeeshwar Reddy on 13/07/18.
//  Copyright © 2018 Tesco. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController, UISearchBarDelegate {

    var searchController : UISearchController!
    var products: [Product]?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var barview: UIView!
    @IBOutlet weak var loadingStatusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.searchController = UISearchController(searchResultsController:  nil)
        
        self.searchController.searchBar.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.searchBar.placeholder = "Search for a product"
        
        self.navigationItem.titleView = searchController.searchBar
        
        self.definesPresentationContext = true
        tableView.tableFooterView = UIView()
        self.extendedLayoutIncludesOpaqueBars = true
        
        //Load recommendations
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        Mango.offerProducts { [weak self] products in
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true
            self?.searchController.isActive = false
            self?.loadingStatusLabel.isHidden = true
            if let offerProducts = products {
                let filtered = offerProducts.filter({
                    guard let profile = Container.resolver.currentProfile else { return false }
                    return $0.healthCode(for: profile) == .good
                })
                
                self?.products = filtered
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        barview.layoutIfNeeded()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        products = []
        tableView.reloadData()
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchFor(text: searchBar.text ?? "")
    }
    
    func searchFor(text: String) {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        Mango.searchForProduct(name: text) { [weak self] products in
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true
            self?.searchController.isActive = false
            if let searchedProducts = products {
                self?.products = searchedProducts
                self?.tableView.reloadData()
            }
        }
    }
}

extension ShopViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        let contentView = ProductContentView.loadFromNib()
        if let product = products?[indexPath.row] {
            contentView.configure(with: product)
        }
        cell.addContainedSubview(contentView)
        return cell
    }    
}
