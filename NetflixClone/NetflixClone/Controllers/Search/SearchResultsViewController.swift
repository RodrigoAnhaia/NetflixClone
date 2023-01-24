//
//  SearchResultsViewController.swift
//  NetflixClone
//
//  Created by Rodrigo Sanseverino de Anhaia on 24/01/23.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    public var titles: [Title] = [Title]()
    
    public let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width / 3 - 10)
        layout.itemSize = CGSize(width: width, height: 200)
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setupLayout()
        
        self.searchResultsCollectionView.delegate = self
        self.searchResultsCollectionView.dataSource = self
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.searchResultsCollectionView.frame = self.view.bounds
    }
}

extension SearchResultsViewController {
    fileprivate func setupLayout() {
        self.view.addSubview(self.searchResultsCollectionView)
    }
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let titles = titles[indexPath.row]
        cell.configure(with: titles.poster_path ?? "")
        
        return cell
    }
    
    
}
