//
//  HeroHeaderUIView.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 4/27/22.
//

import UIKit

//MARK: - Protocol
protocol HeroHeaderUIViewDelegate: AnyObject {
    func heroHeaderUIViewDelegateDidTapPlay(title: Title)
    func heroHeaderUIViewDelegateDidTapDownload(title: Title)
}

//Hero Section in the Home Tab
class HeroHeaderUIView: UIView {
    
//MARK: - Properties
    weak var delegate: HeroHeaderUIViewDelegate?
    private var title: Title?
    
//MARK: - Subviews
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        return imageView
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
//MARK: - Init
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubviews() //includes adding gradient
        applyButtonConstraints()
        addActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    private func addSubviews() {
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
    }

//MARK: - Configure
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    public func configure(with model: Title) {
        self.title = model
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.poster_path ?? "")") else { return }
        heroImageView.sd_setImage(with: url, completed: nil)
    }
    
    private func addActions() {
        playButton.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(didTapDownloadButton), for: .touchUpInside)
    }
    
//MARK: - Actions
    @objc private func didTapPlayButton() {
        guard let title = self.title else {return}
        UIButton.animate(withDuration: 0.1) {[weak self] in
            self?.playButton.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        } completion: { [weak self] success in
            UIButton.animate(withDuration: 0.1) {
                self?.playButton.transform = CGAffineTransform.identity
            }
        }
        delegate?.heroHeaderUIViewDelegateDidTapPlay(title: title)
    }
    
    @objc private func didTapDownloadButton() {
        guard let title = self.title else {return}
        UIButton.animate(withDuration: 0.2) {[weak self] in
            self?.downloadButton.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        } completion: { [weak self] success in
            UIButton.animate(withDuration: 0.2) {
                self?.downloadButton.transform = CGAffineTransform.identity
                self?.downloadButton.titleLabel?.textColor = .systemGreen
                self?.downloadButton.layer.borderColor = UIColor.systemGreen.cgColor
            }
        }
        delegate?.heroHeaderUIViewDelegateDidTapDownload(title: title)
    }
}

//MARK: - Constraints
extension HeroHeaderUIView {
    private func applyButtonConstraints() {
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            playButton.widthAnchor.constraint(equalToConstant: 120)        ]
        
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
}
