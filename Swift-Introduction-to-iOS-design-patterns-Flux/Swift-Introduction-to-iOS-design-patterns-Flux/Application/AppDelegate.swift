//
//  AppDelegate.swift
//  Swift-Introduction-to-iOS-design-patterns-Flux
//
//  Created by kazunori.aoki on 2021/10/11.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private let actionCreator = ActionCreator()
    private let searchStore = SearchRepositoryStore.shared
    private let favoriteStore = FavoriteRepositoryStore.shared
    private let selectedStore = SelectedRepositoryStore.shared
    
    private lazy var showRepositoryDetailSubscription: Subscription = {
        return selectedStore.addListener { [weak self] in
            DispatchQueue.main.async {
                guard let me = self,
                      me.selectedStore.repository != nil,
                      let tabBarController = me.window?.rootViewController as? UITabBarController,
                      let navigationController = tabBarController.selectedViewController as? UINavigationController
                else { return }
                
                let vc = RepositoryDetailViewController()
                navigationController.pushViewController(vc, animated: true)
            }
        }
    }()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let tabBarController = window?.rootViewController as? UITabBarController {
            let values: [(UINavigationController, UITabBarItem.SystemItem)] = [
                (UINavigationController(rootViewController: RepositorySearchViewController()), .search),
                (UINavigationController(rootViewController: FavoritesViewController()), .favorites)
            ]
            values.enumerated().forEach {
                $0.element.0.tabBarItem = UITabBarItem(tabBarSystemItem: $0.element.1, tag: $0.offset)
            }
            tabBarController.setViewControllers(values.map { $0.0 }, animated: false)
        }
        
        _ = showRepositoryDetailSubscription
        actionCreator.loadFavoriteRepositories()
        
        return true
    }
}
