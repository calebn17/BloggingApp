//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 4/27/22.
//

import UIKit

//MARK: - Protocol
protocol HomeCollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: HomeCollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
}

//The Rowlist for each section in the Home Tab
class HomeCollectionViewTableViewCell: UITableViewCell {

//MARK: - Properties
    static let identifier = "HomeCollectionViewTableViewCell"
    weak var delegate: HomeCollectionViewTableViewCellDelegate?
    private var titles: [Title] = []
    
//MARK: - Subviews
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
//MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
//MARK: - Configure
    public func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func downloadTitleAt(indexPath: IndexPath) {
        let title = titles[indexPath.row]
        Task {
            try await HomeViewModel.downloadTitle(title: title)
        }
    }
}

extension HomeCollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TitleCollectionViewCell.identifier,
            for: indexPath
        ) as? TitleCollectionViewCell
        else {return UICollectionViewCell()}
        
        guard let model = titles[indexPath.row].poster_path else {return UICollectionViewCell()}
        cell.configure(with: model)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        Task {
            guard let viewModel = try await HomeViewModel.fetchMovie(title: title) else {return}
            self.delegate?.collectionViewTableViewCellDidTapCell(self, viewModel: viewModel)
        }
    }
    
    // Long press to download
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {[weak self] _ in
            let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                self?.downloadTitleAt(indexPath: indexPath)
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
}
