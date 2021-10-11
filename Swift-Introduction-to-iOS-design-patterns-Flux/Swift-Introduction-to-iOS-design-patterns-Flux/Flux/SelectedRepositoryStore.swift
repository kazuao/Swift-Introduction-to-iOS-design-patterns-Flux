//
//  SelectedRepositoryStore.swift
//  Swift-Introduction-to-iOS-design-patterns-Flux
//
//  Created by kazunori.aoki on 2021/10/11.
//

import GitHub

final class SelectedRepositoryStore: Store {
    static let shared = SelectedRepositoryStore(dispatcher: .shared)

    private(set) var repository: GitHub.Repository?

    override func onDispatch(_ action: Action) {
        switch action {
        case let .selectedRepository(repository):
            self.repository = repository

        case .searchRepositories,
             .clearSearchRepositories,
             .searchPagination,
             .isRepositoriesFetching,
             .isSearchFieldEditing,
             .error,
             .searchQuery,
             .setFavoriteRepositories:
            return
        }
        emitChange()
    }
}

