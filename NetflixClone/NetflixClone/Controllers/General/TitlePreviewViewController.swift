//
//  TitlePreviewViewController.swift
//  NetflixClone
//
//  Created by Rodrigo Sanseverino de Anhaia on 24/01/23.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.minimumScaleFactor = 0.8
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Harry Potter"
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.minimumScaleFactor = 0.8
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "This is the best movie ever to watch as a kid!"
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setupLayout()
        self.setupConstraints()
    }
}

extension TitlePreviewViewController {
    fileprivate func setupLayout() {
        self.view.addSubview(self.webView)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.overviewLabel)
        self.view.addSubview(self.downloadButton)
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            self.webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.webView.heightAnchor.constraint(equalToConstant: 280),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.webView.bottomAnchor, constant: 20),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            self.overviewLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 15),
            self.overviewLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.overviewLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
           
            self.downloadButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.downloadButton.topAnchor.constraint(equalTo: self.overviewLabel.bottomAnchor, constant: 25),
            self.downloadButton.widthAnchor.constraint(equalToConstant: 140),
            self.downloadButton.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
    
    func configure(with model: TitlePreviewViewModel) {
        self.titleLabel.text = model.title
        self.overviewLabel.text = model.titleOverview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else { return }
        
        self.webView.load(URLRequest(url: url))
    }
}
