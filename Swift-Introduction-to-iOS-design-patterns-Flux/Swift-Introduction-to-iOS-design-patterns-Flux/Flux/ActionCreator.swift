//
//  ActionCreator.swift
//  Swift-Introduction-to-iOS-design-patterns-Flux
//
//  Created by kazunori.aoki on 2021/10/11.
//

import GitHub

final class ActionCreator {
    
    // MARK: Variable
    private let dispatcher: Dispatcher
    private let apiSession: GitHubApiRequestable
    private let localCache: LocalCachable
    
    
    // MARK: Initialize
    init(dispatcher: Dispatcher = .shared,
         apiSession: GitHubApiRequestable = GitHubApiSession.shared,
         localCache: LocalCachable = LocalCache.shared)
    {
        self.dispatcher = dispatcher
        self.apiSession = apiSession
        self.localCache = localCache
    }
}


// MARK: - Search
extension ActionCreator {
    func searchRepositoryies(query: String, page: Int = 1) {
        dispatcher.dispatch(.searchQuery(query))
        dispatcher.dispatch(.isRepositoriesFetching(true))
        apiSession.searchRepositories(query: query, page: page) { [dispatcher] result in
            switch result {
            case let .success((repositories, pagination)):
                dispatcher.dispatch(.searchRepositories(repositories))
                dispatcher.dispatch(.searchPagination(pagination))
                
            case let .failure(error):
                dispatcher.dispatch(.error(error))
            }
            dispatcher.dispatch(.isRepositoriesFetching(false))
        }
    }
    
    func setIsSearchFieldEditing(_ isEditing: Bool) {
        dispatcher.dispatch(.isSearchFieldEditing(isEditing))
    }
    
    func clearRepositories() {
        dispatcher.dispatch(.clearSearchRepositories)
    }
}


// MARK: - Favorite
extension ActionCreator {
    func addFavoriteRepository(_ repository: GitHub.Repository) {
        let repositories = localCache[.favorites] + [repository]
        localCache[.favorites] = repositories
        dispatcher.dispatch(.setFavoriteRepositories(repositories))
    }
    
    func removeFavoriteRepository(_ repository: GitHub.Repository) {
        let repositories = localCache[.favorites].filter { $0.id != repository.id }
        localCache[.favorites] = repositories
        dispatcher.dispatch(.setFavoriteRepositories(repositories))
    }
    
    func loadFavoriteRepositories() {
        dispatcher.dispatch(.setFavoriteRepositories(localCache[.favorites]))
    }
}


// MARK: - Others
extension ActionCreator {
    func setSelectedRepository(_ repository: GitHub.Repository?) {
        dispatcher.dispatch(.selectedRepository(repository))
    }
}
