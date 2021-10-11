//
//  RepositorySearchDataSource.swift
//  Swift-Introduction-to-iOS-design-patterns-Flux
//
//  Created by kazunori.aoki on 2021/10/11.
//

import UIKit
import GitHub

final class RepositorySearchDataSource: NSObject {
    private let searchStore: SearchRepositoryStore
    private let actionCreator: ActionCreator
    
    init(searchStore: SearchRepositoryStore, actionCreator: ActionCreator) {
        self.searchStore = searchStore
        self.actionCreator = actionCreator
        
        super.init()
    }
    
    func configure(_ tableView: UITableView) {
        tableView.register(GitHub.RepositoryCell.nib, forCellReuseIdentifier: GitHub.RepositoryCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}


// MARK: - UITableViewDataSource
extension RepositorySearchDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchStore.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GitHub.RepositoryCell.identifier, for: indexPath)
        
        if let repositoryCell = cell as? GitHub.RepositoryCell {
            let repository = searchStore.repositories[indexPath.row]
            repositoryCell.configure(with: repository)
        }
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension RepositorySearchDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let repository = searchStore.repositories[indexPath.row]
        actionCreator.setSelectedRepository(repository)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let query = searchStore.query,
           let next = searchStore.pagination?.next,
           searchStore.pagination?.last != nil
            && scrollView.contentSize.height > 0
            && (scrollView.contentSize.height - scrollView.bounds.size.height) <= scrollView.contentOffset.y
            && !searchStore.isFetching
        {
            actionCreator.searchRepositoryies(query: query, page: next)
        }
    }
}
