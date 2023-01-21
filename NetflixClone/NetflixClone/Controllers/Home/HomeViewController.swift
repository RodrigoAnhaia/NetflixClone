//
//  ViewController.swift
//  NetflixClone
//
//  Created by Rodrigo Sanseverino de Anhaia on 16/01/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    private lazy var homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self,
                       forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setupLayout()
        self.setupHeaderView()
        self.configureNavBar()
        
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
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 450))
        self.homeFeedTable.tableHeaderView = headerView
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = self.view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        self.navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}
