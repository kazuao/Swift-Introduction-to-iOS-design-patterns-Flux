//
//  SearchRepositoryStore.swift
//  Swift-Introduction-to-iOS-design-patterns-Flux
//
//  Created by kazunori.aoki on 2021/10/11.
//

import GitHub

final class SearchRepositoryStore: Store {
    static let shared = SearchRepositoryStore(dispatcher: .shared)
    
    private(set) var query: String?
    private(set) var pagination: GitHub.Pagination?
    private(set) var isSearchFieldEditing = false
    private(set) var isFetching = false
    private(set) var error: Error?
    
    private(set) var repositories: [GitHub.Repository] = []
    
    override func onDispatch(_ action: Action) {
        switch action {
        case .searchQuery(let query):
            self.query = query
            
        case .searchPagination(let pagination):
            self.pagination = pagination
            
        case .searchRepositories(let repositories):
            self.repositories.append(contentsOf: repositories)
            
        case .clearSearchRepositories:
            self.repositories.removeAll()
            
        case .isRepositoriesFetching(let isFetching):
            self.isFetching = isFetching
            
        case .isSearchFieldEditing(let isEditing):
            self.isSearchFieldEditing = isEditing
            
        case .error(let error):
            self.error = error

        case .selectedRepository, .setFavoriteRepositories:
            return
        }
        emitChange()
    }
}
