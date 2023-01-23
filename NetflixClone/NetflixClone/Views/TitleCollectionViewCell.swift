//
//  TitleCollectionViewCell.swift
//  NetflixClone
//
//  Created by Rodrigo Sanseverino de Anhaia on 21/01/23.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Could not render \(TitleCollectionViewCell.self)")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.posterImageView.frame = self.contentView.bounds
    }
}

extension TitleCollectionViewCell {
    fileprivate func setupLayout() {
        self.addSubview(self.posterImageView)
    }
    
    public func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else { return }
        self.posterImageView.sd_setImage(with: url)
    }
}
