//
//  ActorsCollectionView.swift
//  NetflixClone
//
//  Created by Rodrigo Sanseverino de Anhaia on 14/02/23.
//

import UIKit

class ActorsCollectionView: UIView {

    private let actorsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
