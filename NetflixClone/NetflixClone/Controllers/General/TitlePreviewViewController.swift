//
//  TitlePreviewViewController.swift
//  NetflixClone
//
//  Created by Rodrigo Sanseverino de Anhaia on 24/01/23.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    private var ringView: RingView = RingView()
    private var backgroundImage: BackgroundView = BackgroundView(frame: .zero)
    
    private lazy var titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.minimumScaleFactor = 0.8
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.text = "2023-03-01"
        let components = label.text?.components(separatedBy: "-")
        let reversedComponents = components!.reversed()
        let reversedString = reversedComponents.joined(separator: "/")
        label.text = reversedString
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.minimumScaleFactor = 0.8
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Ant-Man and the Wasp: Quantumania"
        return label
    }()
    
    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.minimumScaleFactor = 0.8
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.text = "Adventure, SCI-FI, Horror, Animation"
        let components = label.text?.components(separatedBy: "-")
        let reversedComponents = components!.reversed()
        let reversedString = reversedComponents.joined(separator: "/")
        label.text = reversedString
        return label
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.minimumScaleFactor = 0.8
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "Scott Lang and Hope Van Dyne, along with Hank Pym and Janet Van Dyne, explore the Quantum Realm, where they interact with strange creatures and embark on an adventure that goes beyond the limits of what they thought was possible."
        return label
    }()
    
    private lazy var youtubeButton: UIButton = {
        let originalImage = UIImage(named: "youtube")!
        let size = CGSize(width: 30, height: 30)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        originalImage.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var configuration = UIButton.Configuration.gray()
        configuration.title = "Youtube"
        configuration.baseForegroundColor = .white
        configuration.image = resizedImage
        configuration.imagePlacement = .leading
        configuration.titlePadding = 10
        configuration.imagePadding = 10
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(youtubeButtonTapped), for: .touchUpInside)
        button.tag = 0
        return button
    }()
    
    private lazy var closeYoutubeView: UIButton = {
        let originalImage = UIImage(named: "youtube")!
        let size = CGSize(width: 30, height: 30)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        originalImage.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var configuration = UIButton.Configuration.gray()
        configuration.title = "Close"
        configuration.baseForegroundColor = .white
        configuration.image = resizedImage
        configuration.imagePlacement = .leading
        configuration.titlePadding = 10
        configuration.imagePadding = 10
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(youtubeButtonTapped), for: .touchUpInside)
        button.tag = 1
        return button
    }()
    
    var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setupLayout()
        self.setupConstraints()
        self.navigationItem.hidesBackButton = false
        self.webView.isHidden = true
        self.closeYoutubeView.isHidden = true
    }
    
    func configure(with model: TitlePreviewViewModel, genres: String) {
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)"),
              let urlImage = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }
        
        DispatchQueue.main.async {
            self.webView.load(URLRequest(url: url))
        }
        
        self.titleImageView.sd_setImage(with: urlImage)
        
        self.titleLabel.text = model.title
        self.overviewLabel.text = model.titleOverview
        self.genresLabel.text = genres
        
        /// Release Date Reverse
        let components = model.date.components(separatedBy: "-")
        let reversedComponents = components.reversed()
        let reversedString = reversedComponents.joined(separator: "/")
        
        self.dateLabel.text = reversedString
        
        guard let voteAverage = model.voteAverage else { return }
        self.ringView.updateVoteAverage(voteAverage)
        self.backgroundImage.configure(with: model.posterURL)
        
    }
}

extension TitlePreviewViewController {
    fileprivate func setupLayout() {
        self.view.addSubview(self.backgroundImage)
        self.view.addSubview(self.titleImageView)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.genresLabel)
        self.view.addSubview(self.dateLabel)
        self.view.addSubview(self.ringView)
        self.view.addSubview(self.overviewLabel)
        self.view.addSubview(self.youtubeButton)
        self.view.addSubview(self.closeYoutubeView)
        self.view.addSubview(self.webView)
    }
    
    fileprivate func setupConstraints() {
        self.ringView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.backgroundImage.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.backgroundImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -10),
            self.backgroundImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 10),
            self.backgroundImage.heightAnchor.constraint(equalToConstant: self.view.bounds.height),
            
            ///Title ImageView
            self.titleImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.titleImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.titleImageView.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.35),
            self.titleImageView.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.25),
            
            ///Title Label
            self.titleLabel.topAnchor.constraint(equalTo: self.titleImageView.bottomAnchor, constant: 20),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.titleImageView.centerXAnchor),
            
            ///Genres Label
            self.genresLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 20),
            self.genresLabel.centerXAnchor.constraint(equalTo: self.titleLabel.centerXAnchor),
            
            ///Ring UIView
            self.ringView.centerYAnchor.constraint(equalTo: self.dateLabel.centerYAnchor),
            self.ringView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            
            ///Date Label
            self.dateLabel.topAnchor.constraint(equalTo: self.genresLabel.bottomAnchor, constant: 40),
            self.dateLabel.leadingAnchor.constraint(equalTo: self.ringView.trailingAnchor, constant: 10),
            self.dateLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -80),
            
            ///Overview Label
            self.overviewLabel.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 40),
            self.overviewLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.overviewLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            ///Youtube Button
            self.youtubeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.youtubeButton.topAnchor.constraint(equalTo: self.overviewLabel.bottomAnchor, constant: 25),
            self.youtubeButton.widthAnchor.constraint(equalToConstant: 140),
            self.youtubeButton.heightAnchor.constraint(equalToConstant: 40),
            
            ///WebView
            self.webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.webView.heightAnchor.constraint(equalToConstant: 280),
            
            ///Close YoutubeView Button
            self.closeYoutubeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.closeYoutubeView.topAnchor.constraint(equalTo: self.webView.bottomAnchor, constant: 25),
            self.closeYoutubeView.widthAnchor.constraint(equalToConstant: 140),
            self.closeYoutubeView.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    
    @objc fileprivate func youtubeButtonTapped(sender: UIButton) {
        switch sender.tag {
        case 0:
            self.navigationItem.hidesBackButton = true
            self.webView.isHidden = false
            self.closeYoutubeView.isHidden = false
            self.titleImageView.isHidden = true
            self.titleLabel.isHidden = true
            self.dateLabel.isHidden = true
            self.ringView.isHidden = true
            self.overviewLabel.isHidden = true
            self.youtubeButton.isHidden = true
            
        case 1:
            self.navigationItem.hidesBackButton = false
            self.webView.isHidden = true
            self.closeYoutubeView.isHidden = true
            self.titleImageView.isHidden = false
            self.titleLabel.isHidden = false
            self.dateLabel.isHidden = false
            self.ringView.isHidden = false
            self.overviewLabel.isHidden = false
            self.youtubeButton.isHidden = false
            
        default:
            break
        }
    }
}

// MARK: - UIKit Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct UIViewControllerPreview<TitlePreviewViewController: UIViewController>: UIViewControllerRepresentable {
    let viewController: TitlePreviewViewController
    
    init(_ builder: @escaping () -> TitlePreviewViewController) {
        self.viewController = builder()
    }
    
    // MARK: - UIViewControllerRepresentable
    func makeUIViewController(context: Context) -> TitlePreviewViewController {
        self.viewController
    }
    
    func updateUIViewController(_ uiViewController: TitlePreviewViewController, context: UIViewControllerRepresentableContext<UIViewControllerPreview<TitlePreviewViewController>>) {
        return
    }
}
#endif

#if canImport(SwiftUI) && DEBUG
import SwiftUI

let deviceNames: [String] = [
    "iPhone SE",
    "iPhone 14 Pro Max"
]

@available(iOS 13.0, *)
struct TitlePreviewViewController_Preview: PreviewProvider {
    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewControllerPreview {
                TitlePreviewViewController()
            }.previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif
