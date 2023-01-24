//
//  UpcomingViewController.swift
//  NetflixClone
//
//  Created by Rodrigo Sanseverino de Anhaia on 16/01/23.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var titles: [Title] = [Title]()
    
    private let upcomingTableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "t")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "Upcoming"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        self.setupLayout()
        self.fetchUpcoming()
        
        self.upcomingTableView.delegate = self
        self.upcomingTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.upcomingTableView.frame = self.view.bounds
    }
}

extension UpcomingViewController {
    fileprivate func setupLayout() {
        self.view.addSubview(self.upcomingTableView)
    }
    
    fileprivate func fetchUpcoming() {
        APICaller.shared.getUpcomingMovies { [weak self] resuts in
            switch resuts {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "t", for: indexPath)
        cell.textLabel?.text = self.titles[indexPath.row].original_name ?? self.titles[indexPath.row].original_title ?? "Unknown"
        return cell
    }
    
    
}
