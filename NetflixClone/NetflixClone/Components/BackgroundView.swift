//
//  BackgroundView.swift
//  NetflixClone
//
//  Created by Rodrigo Sanseverino de Anhaia on 06/02/23.
//

import UIKit

class BackgroundView: UIView {

    lazy var backgroundImage: UIImageView = {
        let blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurredView.clipsToBounds = true
        blurredView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurredView.frame = self.bounds
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        imageView.addSubview(blurredView)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.addSubview(self.backgroundImage)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.backgroundImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.backgroundImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.backgroundImage.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.backgroundImage.heightAnchor.constraint(equalTo: self.heightAnchor)
    
        ])
    }
    
    public func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else { return }
        
        self.backgroundImage.sd_setImage(with: url)
    }
}
