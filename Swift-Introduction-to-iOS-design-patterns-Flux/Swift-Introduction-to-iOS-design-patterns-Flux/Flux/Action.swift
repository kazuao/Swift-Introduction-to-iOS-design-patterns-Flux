//
//  Action.swift
//  Swift-Introduction-to-iOS-design-patterns-Flux
//
//  Created by kazunori.aoki on 2021/10/11.
//

import GitHub

enum Action {
    
    // ActionCreatorからDispatcherに送られるAction
    // Actionをもとに、Dispatcherが振る舞いを決める
    
    // MARK: - Search
    case searchQuery(String?)
    case searchPagination(GitHub.Pagination?)
    case searchRepositories([GitHub.Repository])
    case clearSearchRepositories
    case isRepositoriesFetching(Bool)
    case isSearchFieldEditing(Bool)
    case error(Error?)
    
    // MARK: - Favorite
    case setFavoriteRepositories([GitHub.Repository])
    
    // MARK: - Others
    case selectedRepository(GitHub.Repository?)
}
