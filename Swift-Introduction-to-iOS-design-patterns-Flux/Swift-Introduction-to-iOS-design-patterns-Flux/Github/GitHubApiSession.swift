//
//  GitHubApiSession.swift
//  Swift-Introduction-to-iOS-design-patterns-Flux
//
//  Created by kazunori.aoki on 2021/10/11.
//

import Foundation
import GitHub

protocol GitHubApiRequestable: AnyObject {
    func searchRepositories(query: String, page: Int,
                            completion: @escaping (GitHub.Result<([GitHub.Repository], GitHub.Pagination)>) -> ())
}

final class GitHubApiSession: GitHubApiRequestable {
    static let shared = GitHubApiSession()
    
    private let session = GitHub.Session()
    
    func searchRepositories(query: String, page: Int, completion: @escaping (Result<([Repository], Pagination)>) -> ()) {
        let request = SearchRepositoriesRequest(query: query, sort: .stars, order: .desc, page: page, perPage: nil)
        session.send(request) { result in
            switch result {
            case let .success((response, pagination)):
                completion(.success((response.items, pagination)))
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
