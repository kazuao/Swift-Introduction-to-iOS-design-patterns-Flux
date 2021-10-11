//
//  RepositorySearchViewController.swift
//  Swift-Introduction-to-iOS-design-patterns-Flux
//
//  Created by kazunori.aoki on 2021/10/11.
//

import UIKit
import GitHub

class RepositorySearchViewController: UIViewController {

    // MARK: UI
    @IBOutlet private(set) weak var searchBar: UISearchBar!
    @IBOutlet private(set) weak var tableView: UITableView!
    
    
    // MARK: Variable
    private let searchStore: SearchRepositoryStore     // Input
    private let selectedStore: SelectedRepositoryStore
    private let actionCreator: ActionCreator           // Output
    private let dataSource: RepositorySearchDataSource // View
    
    private let debounce = DispatchQueue.main.debounce(delay: .milliseconds(300))
    
    private lazy var reloadSubscription: Subscription = {
        return searchStore.addListener { [weak self] in
            self?.debounce {
                self?.tableView.reloadData()
                self?.refrectEditing()
            }
        }
    }()
    
    // MARK: Initialize
    init(searchStore: SearchRepositoryStore = .shared,
         selectedStore: SelectedRepositoryStore = .shared,
         actionCreator: ActionCreator = .init()) {
        self.searchStore = searchStore
        self.selectedStore = selectedStore
        self.actionCreator = actionCreator
        self.dataSource = RepositorySearchDataSource(searchStore: searchStore, actionCreator: actionCreator)
        
        super.init(nibName: "RepositorySearchViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        searchStore.removeListener(reloadSubscription)
    }
    
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search Repository"
        
        dataSource.configure(tableView)
        searchBar.delegate = self
        
        _ = reloadSubscription
    }
}


// MARK: - Private
private extension RepositorySearchViewController {
    
    func refrectEditing() {
        UIView.animate(withDuration: 0.3) {
            if self.searchStore.isSearchFieldEditing {
                self.view.backgroundColor = .black
                self.tableView.isUserInteractionEnabled = false
                self.tableView.alpha = 0.5
                self.searchBar.setShowsCancelButton(true, animated: true)
            } else {
                self.searchBar.resignFirstResponder()
                self.view.backgroundColor = .white
                self.tableView.isUserInteractionEnabled = true
                self.tableView.alpha = 1.0
                self.searchBar.setShowsCancelButton(false, animated: true)
            }
        }
    }
}

extension RepositorySearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        actionCreator.setIsSearchFieldEditing(true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        actionCreator.setIsSearchFieldEditing(false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            actionCreator.clearRepositories()
            actionCreator.searchRepositoryies(query: text)
            actionCreator.setIsSearchFieldEditing(false)
        }
    }
}
