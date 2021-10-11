//
//  FavoriteRepositoryStore.swift
//  Swift-Introduction-to-iOS-design-patterns-Flux
//
//  Created by kazunori.aoki on 2021/10/11.
//

import GitHub

final class FavoriteRepositoryStore: Store {
    static let shared = FavoriteRepositoryStore(dispatcher: .shared)

    private(set) var repositories: [GitHub.Repository] = []

    override func onDispatch(_ action: Action) {
        switch action {
        case let .setFavoriteRepositories(repositories):
            self.repositories = repositories

        case .selectedRepository,
             .searchRepositories,
             .clearSearchRepositories,
             .searchPagination,
             .isRepositoriesFetching,
             .isSearchFieldEditing,
             .searchQuery,
             .error:
            return

        }
        emitChange()
    }
}

