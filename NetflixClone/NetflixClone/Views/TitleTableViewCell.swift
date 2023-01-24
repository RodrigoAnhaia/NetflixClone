//
//  TitleTableViewCell.swift
//  NetflixClone
//
//  Created by Rodrigo Sanseverino de Anhaia on 24/01/23.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    static let identifier = "TitleTableViewCell"
    
    private let playButton: UIButton = {
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titlePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayout()
        self.setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Could not render \(TitleTableViewCell.self)")
    }
    
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }
        
        self.titlePosterImageView.sd_setImage(with: url)
        self.titleLabel.text = model.titleName
    }
}

extension TitleTableViewCell {
    fileprivate func setupLayout() {
        self.contentView.addSubview(self.titlePosterImageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.playButton)
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            self.titlePosterImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.titlePosterImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.titlePosterImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            self.titlePosterImageView.widthAnchor.constraint(equalToConstant: 100),
             
            self.titleLabel.leadingAnchor.constraint(equalTo: self.titlePosterImageView.trailingAnchor, constant: 20),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.playButton.leadingAnchor, constant: -10),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            self.playButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.playButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.playButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
