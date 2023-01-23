//
//  TableViewCell.swift
//  NetflixClone
//
//  Created by Rodrigo Sanseverino de Anhaia on 19/01/23.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {

   static let identifier = "CollectionViewTableViewCell"
    
    private var titles: [Title] = [Title]()
    
    private let collectionView: UICollectionView = {
        /// Styling layout to collection view
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        /// Collection veiw
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayout()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    
    required init?(coder: NSCoder) {
        fatalError("Could not create cell: \(CollectionViewTableViewCell.identifier)")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.contentView.bounds
    }
    
    public func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [ weak self ] in
            self?.collectionView.reloadData()
        }
    }
}

extension CollectionViewTableViewCell {
    fileprivate func setupLayout() {
        self.contentView.addSubview(self.collectionView)
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let model = self.titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: model)
        
        return cell
    }
}
