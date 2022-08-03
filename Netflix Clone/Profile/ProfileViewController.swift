//
//  ProfileViewController.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 8/2/22.
//

import UIKit

class ProfileViewController: UIViewController {
    weak var coordinator: ProfileCoordinator?
    
    private let viewModels = ProfileViewModel.models
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        table.isScrollEnabled = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavbar()
        addSubViews()
        //addConstraints()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = CGRect(x: 0, y: 300, width: view.width, height: 500)
    }
    
    private func configureNavbar() {
    }
    
    private func addSubViews() {
        view.addSubview(tableView)
    }
    
    private func addActions() {
        
    }
    
    @objc private func didTapClose() {
        
    }
    

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as? ProfileTableViewCell
        else {return UITableViewCell()}
        cell.accessoryType = .disclosureIndicator
        
        switch indexPath.row {
        case 0:
            cell.configure(with: viewModels[0])
        case 1:
            cell.configure(with: viewModels[1])
        case 2:
            cell.configure(with: viewModels[2])
        case 3:
            cell.configure(with: viewModels[3])
        default:
            cell.configure(with: viewModels[4])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0: break
        case 1: break
        case 2: break
        case 3: break
        default: coordinator?.presentSignOut(sender: self)
        }
    }
    
    
}

