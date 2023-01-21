//
//  TableViewCell.swift
//  NetflixClone
//
//  Created by Rodrigo Sanseverino de Anhaia on 19/01/23.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {

   static let identifier = "CollectionViewTableViewCell"
    
    private let collectionView: UICollectionView = {
        /// Styling layout to collection view
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        /// Collection veiw
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .systemPink
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
}

extension CollectionViewTableViewCell {
    fileprivate func setupLayout() {
        self.contentView.addSubview(self.collectionView)
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        
        cell.backgroundColor = .green
        
        return cell
    }
}
