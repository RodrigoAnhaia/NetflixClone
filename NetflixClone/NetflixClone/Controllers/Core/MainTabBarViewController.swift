//
//  MainTabBarViewController.swift
//  NetflixClone
//
//  Created by Rodrigo Sanseverino de Anhaia on 16/01/23.
//

import UIKit

enum TabBarPage: CaseIterable {
    case home
    case upcoming
    case search
    case download
    
    var icons: UIImage {
        switch self {
        case .home:
            return UIImage(systemName: "house")!
        case .upcoming:
            return UIImage(systemName: "play.circle")!
        case .search:
            return UIImage(systemName: "magnifyingglass")!
        case .download:
            return UIImage(systemName: "arrow.down.to.line")!
        }
    }
    
    var selected: UIImage {
        switch self {
        case .home:
            return UIImage(systemName: "house.fill")!
        case .upcoming:
            return UIImage(systemName: "play.circle.fill")!
        case .search:
            return UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration( weight: .bold))!
        case .download:
            return UIImage(systemName: "arrow.down.to.line", withConfiguration: UIImage.SymbolConfiguration( weight: .bold))!
        }
    }
    
    var names: String {
        switch self {
        case .home:
            return "Home"
        case .upcoming:
            return "Upcoming"
        case .search:
            return "Search"
        case .download:
            return "Downloads"
        }
    }
    
    var name: String {
        hashValue.description.capitalized
    }
    
    var id: String {
        name
    }
    
}

class MainTabBarViewController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.setupTabBar()
    }
}

extension MainTabBarViewController {
    fileprivate func setupTabBar() {
        /// Styling
        let appearance = UITabBarAppearance()
        let itemApperance = UITabBarItemAppearance()
        let selectedFont = UIFont.systemFont(ofSize: 12, weight: .bold)
        
        itemApperance.normal.iconColor = .systemGray
        itemApperance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemGray]
        itemApperance.selected.iconColor = .label
        itemApperance.selected.titleTextAttributes = [.font: selectedFont, .foregroundColor: UIColor.label]
        appearance.stackedLayoutAppearance = itemApperance
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
        
        /// Instantiating ViewControllers
        let home = UINavigationController(rootViewController: HomeViewController())
        let upcoming = UINavigationController(rootViewController: UpcomingViewController())
        let search = UINavigationController(rootViewController: SearchViewController())
        let downloads = UINavigationController(rootViewController: DownloadsViewController())
        
        /// TabBar configuration
        home.title = TabBarPage.home.names
        upcoming.title = TabBarPage.upcoming.names
        search.title = TabBarPage.search.names
        downloads.title = TabBarPage.download.names
        
        home.tabBarItem.image = TabBarPage.home.icons
        upcoming.tabBarItem.image = TabBarPage.upcoming.icons
        search.tabBarItem.image = TabBarPage.search.icons
        downloads.tabBarItem.image = TabBarPage.download.icons
        
        
        home.tabBarItem.selectedImage = TabBarPage.home.selected
        upcoming.tabBarItem.selectedImage = TabBarPage.upcoming.selected
        search.tabBarItem.selectedImage = TabBarPage.search.selected
        downloads.tabBarItem.selectedImage = TabBarPage.download.selected
        
        setViewControllers([home, upcoming, search, downloads], animated: true)
        
    }
}
