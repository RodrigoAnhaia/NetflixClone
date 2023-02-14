//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Rodrigo Sanseverino de Anhaia on 16/01/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var titles: [Title] = [Title]()
    
    private let discoverTableView: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let search = UISearchController(searchResultsController: SearchResultsViewController())
        search.searchBar.placeholder = "Search for a Movie or a Tv Show"
        search.searchBar.searchBarStyle = .minimal
        return search
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "Search"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        self.setupLayout()
        self.fetchDiscoverMovies()
        
        self.discoverTableView.delegate = self
        self.discoverTableView.dataSource = self
        
        self.navigationController?.navigationBar.tintColor = .white
        self.searchController.searchResultsUpdater = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.discoverTableView.frame = self.view.bounds
    }
}

extension SearchViewController {
    fileprivate func setupLayout() {
        self.view.addSubview(self.discoverTableView)
        self.navigationItem.searchController = self.searchController
    }
    
    fileprivate func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.discoverTableView.reloadData()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
            
        }
        
        let title = titles[indexPath.row]
        let model = TitleViewModel(titleName: title.original_title ?? title.title ?? "Unknown", posterURL: title.poster_path ?? "")
        
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = self.titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.title else { return }
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? "Unknown", date: title.release_date ?? "", posterURL: title.poster_path ?? "", voteAverage: title.vote_average), genres: "lol")
                    
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel, genres: "lol")
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
        !query.trimmingCharacters(in: .whitespaces).isEmpty,
        query.trimmingCharacters(in: .whitespaces).count >= 3,
        let resultController = searchController.searchResultsController as? SearchResultsViewController else { return }
        
        resultController.delegate = self
        
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultController.titles = titles
                    resultController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(String(describing: error))
                }
            }
        }
    }
}
