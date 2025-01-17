//
//  ProfileViewController.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 8/2/22.
//

import UIKit

class ProfileViewController: UIViewController {
    
//MARK: - Properties
    weak var coordinator: ProfileCoordinator?
    private var currentUser: User { return ProfileViewModel().currentUser }
    private var profileViewModel = ProfileViewModel()
    
//MARK: - Subviews
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .label
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.label.cgColor
        imageView.layer.borderWidth = 2
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 1
        label.clipsToBounds = true
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        table.isScrollEnabled = false
        return table
    }()

//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavbar()
        addSubViews()
        addConstraints()
        updateUI()
        fetchUserData()
        addActions()
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = CGRect(x: 0, y: 300, width: view.width, height: 500)
    }
    
    private func addSubViews() {
        view.addSubview(profileImage)
        view.addSubview(usernameLabel)
        view.addSubview(tableView)
    }
    
//MARK: - Configure
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureNavbar() {}
    
    private func updateUI() {
        profileViewModel.profilePicture.bind {[weak self] viewModel in
            self?.profileImage.sd_setImage(with: self?.profileViewModel.profilePicture.value?.pictureUrl, completed: nil)
        }
    }
    
    private func addActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImage))
        profileImage.addGestureRecognizer(tap)
    }
    
//MARK: - Networking
    private func fetchUserData() {
        usernameLabel.text = currentUser.username
        Task {
            try await profileViewModel.getProfilePicture(user: currentUser)
        }
    }
    
//MARK: - Actions
    @objc private func didTapProfileImage() {
        coordinator?.presentImagePicker(sender: self)
    }
}

//MARK: - ImagePicker Methods
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        profileImage.image = image
        Task {
            try await ProfileViewModel.uploadProfilePicture(user: currentUser, data: image.pngData())
        }
    }
}

//MARK: - TableView Methods
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileViewModel.tableViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as? ProfileTableViewCell
        else {return UITableViewCell()}
        cell.accessoryType = .disclosureIndicator
        let tableViewModels = profileViewModel.tableViewModels
        switch indexPath.row {
        case 0:  cell.configure(with: tableViewModels[0])
        case 1:  cell.configure(with: tableViewModels[1])
        case 2:  cell.configure(with: tableViewModels[2])
        case 3:  cell.configure(with: tableViewModels[3])
        default: cell.configure(with: tableViewModels[4])
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

extension ProfileViewController {
    private func addConstraints() {
        let profileImageConstraints = [
            profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 125),
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileImage.widthAnchor.constraint(equalToConstant: 80),
            profileImage.heightAnchor.constraint(equalToConstant: 80)
        ]
        let usernameLabelConstraints = [
            usernameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10),
            usernameLabel.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor)
        ]
        NSLayoutConstraint.activate(profileImageConstraints)
        NSLayoutConstraint.activate(usernameLabelConstraints)
    }
}

