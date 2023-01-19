//
//  TableViewCell.swift
//  NetflixClone
//
//  Created by Rodrigo Sanseverino de Anhaia on 19/01/23.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {

   static let identifier = "CollectionViewTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .systemPink
    }

    
    required init?(coder: NSCoder) {
        fatalError("Do not create cell with \(CollectionViewTableViewCell.identifier)")
    }
}
