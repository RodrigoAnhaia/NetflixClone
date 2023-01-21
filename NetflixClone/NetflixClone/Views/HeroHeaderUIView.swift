//
//  HeroHeaderUIView.swift
//  NetflixClone
//
//  Created by Rodrigo Sanseverino de Anhaia on 19/01/23.
//

import UIKit

class HeroHeaderUIView: UIView {
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        return imageView
    }()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupConstraints()
        self.addGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Cannot rendenring HeroHeaderUIView")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.heroImageView.frame = self.bounds 
    }
}

extension HeroHeaderUIView {
    //MARK: - SetupLayout
    fileprivate func setupLayout() {
        self.addSubview(self.heroImageView)
        self.addSubview(self.playButton)
        self.addSubview(self.downloadButton)
    }
    
    //MARK: - Setup Constraints
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            /// Play Button
            self.playButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 70),
            self.playButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            self.playButton.widthAnchor.constraint(equalToConstant: 120),
            
            /// Download Button
            self.downloadButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -70),
            self.downloadButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            self.downloadButton.widthAnchor.constraint(equalToConstant: 120),
            ])
    }
    
    //MARK: - Add Gradient
    fileprivate func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
    }
}
