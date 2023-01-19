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
        
        self.homeFeedTable.delegate = self
        self.homeFeedTable.dataSource = self
        
        self.homeFeedTable.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 450))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.homeFeedTable.frame = self.view.bounds
    }
}

extension HomeViewController {
    fileprivate func setupLayout() {
        self.view.addSubview(self.homeFeedTable)
      }

    fileprivate func setupConstraints() {
    }
}

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
}
