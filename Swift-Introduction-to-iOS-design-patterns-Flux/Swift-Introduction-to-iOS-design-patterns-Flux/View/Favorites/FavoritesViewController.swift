//
//  FavoriteViewController.swift
//  Swift-Introduction-to-iOS-design-patterns-Flux
//
//  Created by kazunori.aoki on 2021/10/11.
//

import UIKit

class FavoritesViewController: UIViewController {

    // MARK: UI
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Variable
    private let selectedStore: SelectedRepositoryStore
    private let favoriteStore: FavoriteRepositoryStore
    private let actionCreator: ActionCreator
    private let dataSource: FavoritesDataSource
    
    private lazy var reloadSubscription: Subscription = {
        return favoriteStore.addListener { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
            }
        }
    }()
    
    
    // MARK: Initialize
    init(selectedStore: SelectedRepositoryStore = .shared,
         favoriteStore: FavoriteRepositoryStore = .shared,
         actionCreator: ActionCreator = .init()) {
        self.selectedStore = selectedStore
        self.favoriteStore = favoriteStore
        self.actionCreator = actionCreator
        self.dataSource = FavoritesDataSource(favoriteStore: favoriteStore,
                                              actionCreator: actionCreator)

        super.init(nibName: "FavoritesViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Favorites"
        dataSource.configure(tableView)
        _ = reloadSubscription
    }
}
