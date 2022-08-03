//
//  ProfileTableViewCell.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 8/2/22.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    static let identifier  = "ProfileTableViewCell"
    
    private let symbol: UIImageView = {
        let symbol = UIImageView()
        symbol.image = UIImage(systemName: "checkmark")
        symbol.tintColor = .label
        symbol.translatesAutoresizingMaskIntoConstraints = false
        return symbol
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Label"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(symbol)
        contentView.addSubview(label)
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with viewModel: ProfileModel) {
        symbol.image = UIImage(systemName: viewModel.symbolString ?? "")
        
        if viewModel.label == "Sign Out" {
            label.text = viewModel.label
            label.textColor = .systemRed
        } else {
            label.text = viewModel.label
        }
    }
}

extension ProfileTableViewCell {
    private func constraints() {
        let symbolConstraints = [
            symbol.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            symbol.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ]
        let labelConstraints = [
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: symbol.trailingAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(symbolConstraints)
        NSLayoutConstraint.activate(labelConstraints)
    }
}
