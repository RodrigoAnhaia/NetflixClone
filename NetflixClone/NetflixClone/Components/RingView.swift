//
//  RingView.swift
//  NetflixClone
//
//  Created by Rodrigo Sanseverino de Anhaia on 05/02/23.
//

import UIKit

class RingView: UIView {
    
    lazy var backgroundCircle: UIView = {
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.backgroundColor = .clear
        background.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        background.layer.cornerRadius = 20
        return background
    }()
    
    lazy var overlayCircle: CAShapeLayer = {
        let overlay = CAShapeLayer()
        overlay.lineWidth = 6
        overlay.fillColor = UIColor.clear.cgColor
        return overlay
    }()
    
    lazy var voteAverageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(format: "%.1f", 6,66)
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupLayout()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupLayout() {
        self.addSubview(self.backgroundCircle)
        self.backgroundCircle.layer.addSublayer(overlayCircle)
        self.addSubview(self.voteAverageLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.backgroundCircle.widthAnchor.constraint(equalToConstant: 40),
            self.backgroundCircle.heightAnchor.constraint(equalToConstant: 40),
            self.backgroundCircle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.backgroundCircle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            self.voteAverageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.voteAverageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    public func updateVoteAverage(_ value: Double) {
        let path = UIBezierPath(arcCenter: CGPoint(x: 20, y: 20), radius: 20, startAngle: -.pi / 2, endAngle: (CGFloat(value * 0.1) / 2 * .pi) - .pi / 2, clockwise: false)

        DispatchQueue.main.async {
            self.voteAverageLabel.text = String(format: "%.1f", value)
            self.overlayCircle.strokeColor = (value <= 3 ? UIColor.red.cgColor : (value) < 7 ? UIColor.orange.cgColor : UIColor.green.cgColor)
            self.overlayCircle.path = path.cgPath
        }
    }
}
