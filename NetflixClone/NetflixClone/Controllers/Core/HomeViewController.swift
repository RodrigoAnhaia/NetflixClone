//
//  ViewController.swift
//  NetflixClone
//
//  Created by Rodrigo Sanseverino de Anhaia on 16/01/23.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
    case Animes = 5
}

class HomeViewController: UIViewController {
    
    private var randomTrendingMovie: Title?
    private var heroHeader: HeroHeaderUIView?
    private var titles: [Title] = [Title]()
    
    let sectionTiles: [String] = ["Trending Movies", "Trending TV", "Popular", "Upcoming Movies", "Top Rated", "Animes"]
    
    private lazy var homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self,
                       forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        self.configureNavBar()
        self.setupHeaderView()
        
        self.homeFeedTable.delegate = self
        self.homeFeedTable.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.homeFeedTable.frame = self.view.bounds
    }
}

// MARK: - Funcs
extension HomeViewController {
    fileprivate func setupLayout() {
        self.view.addSubview(self.homeFeedTable)
    }
    
    fileprivate func configureNavBar() {
        /// Image Logo
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        /// Left Bar Button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        self.navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 490)
        
        /// Right Bar Button
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    fileprivate func setupHeaderView() {
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                
                self?.randomTrendingMovie = titles.randomElement()
                self?.heroHeader?.configure(with: TitleViewModel(titleName: selectedTitle?.title ?? selectedTitle?.original_title ?? "Unknown", posterURL: selectedTitle?.poster_path ?? ""))
            case .failure(let error):
                print(String(describing: error))
            }
        }
        
        self.heroHeader = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 450))
        self.homeFeedTable.tableHeaderView = self.heroHeader
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTiles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                    self.titles = titles
                    
                case .failure(let error):
                    print(String(describing: error))
                }
            }
            
        case Sections.TrendingTv.rawValue:
            APICaller.shared.getTrendingTvs { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(String(describing: error))
                }
            }
            
        case Sections.Popular.rawValue:
            APICaller.shared.getPopular { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(String(describing: error))
                }
            }
            
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(String(describing: error))
                }
            }
            
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRated { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(String(describing: error))
                }
            }
            
        case Sections.Animes.rawValue:
            APICaller.shared.getAnimes { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(String(describing: error))
                }
            }
            
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTiles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: (header.bounds.origin.x + 20), y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalized
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = self.view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        self.navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func CollectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        
        guard let title = self.titles.first(where: { $0.title == viewModel.title }) else { return }
        
        APICaller.shared.getMovieRecommendations(with: title.id) { result in
            switch result {
            case .success(let recommendations):
                print(recommendations)
            case .failure(let error):
                print(String(describing: error))
            }
        }
        
        APICaller.shared.getMovieCast(with: title.id) { result in
            switch result {
            case .success(let credits):
                print(credits)
            case .failure(let error):
                print(String(describing: error))
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            
            let genresText = APICaller.shared.getGeneresText(of: title)
            vc.configure(with: viewModel, genres: genresText)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
