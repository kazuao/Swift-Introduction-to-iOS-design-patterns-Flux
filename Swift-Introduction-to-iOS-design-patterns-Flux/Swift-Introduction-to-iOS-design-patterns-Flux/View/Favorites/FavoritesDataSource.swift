//
//  FavoritesDataSource.swift
//  Swift-Introduction-to-iOS-design-patterns-Flux
//
//  Created by kazunori.aoki on 2021/10/11.
//

import UIKit
import GitHub

final class FavoritesDataSource: NSObject {
    
    private let favoriteStore: FavoriteRepositoryStore
    private let actionCreator: ActionCreator

    init(favoriteStore: FavoriteRepositoryStore, actionCreator: ActionCreator) {
        self.favoriteStore = favoriteStore
        self.actionCreator = actionCreator

        super.init()
    }

    func configure(_ tableView: UITableView) {
        tableView.register(GitHub.RepositoryCell.nib,
                           forCellReuseIdentifier: GitHub.RepositoryCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension FavoritesDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteStore.repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GitHub.RepositoryCell.identifier, for: indexPath)

        if let repositoryCell = cell as? GitHub.RepositoryCell {
            let repository = favoriteStore.repositories[indexPath.row]
            repositoryCell.configure(with: repository)
        }

        return cell
    }
}

extension FavoritesDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let repository = favoriteStore.repositories[indexPath.row]
        actionCreator.setSelectedRepository(repository)
    }
}
