//
//  DownloadsViewController.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 4/27/22.
//

import UIKit

class DownloadsViewController: UIViewController {
    
//MARK: - Properties
    weak var coordinator: DownloadsCoordinator?
    private var viewModel = DownloadsViewModel()

//MARK: - Subviews
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTableView()
        addNotificationObserver()
        updateUI()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
//MARK: - Configure
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("downloaded"),
            object: nil,
            queue: nil
        ) { [weak self] _ in
            self?.fetchData()
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    private func updateUI() {
        viewModel.downloadedTitles.bind {[weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
//MARK: - Networking
    private func fetchData() {
        Task {
            try await viewModel.fetchDownloadedTitles()
        }
    }
}

//MARK: - TableView Methods
extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.downloadedTitles.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell,
              let title = viewModel.downloadedTitles.value?[indexPath.row]
        else {return UITableViewCell()}
        
        cell.configure(with: title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let title = viewModel.downloadedTitles.value?[indexPath.row] else {return}
                
        Task {
            guard let model = try await DownloadsViewModel.fetchMovie(title: title) else {return}
            coordinator?.presentPreview(sender: self, model: model)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            Task {
                guard let title = viewModel.downloadedTitles.value?[indexPath.row] else {return}
                await DownloadsViewModel.deleteTitle(with: title)
                
                //remove particular title from titles array FIRST and then delete the tableView row or we will get an error
                viewModel.downloadedTitles.value?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default: break
        }
    }
}
