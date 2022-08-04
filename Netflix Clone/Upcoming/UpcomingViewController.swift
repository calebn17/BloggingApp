//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 4/27/22.
//

import UIKit

//Coming Soon tab
class UpcomingViewController: UIViewController {
    
    weak var coordinator: UpcomingCoordinator?
    private var titles: [Title] = []
    private var viewModel = UpcomingViewModel()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchUpcomingMovies()
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
//MARK: - Configure
    private func updateUI() {
        viewModel.upcomingMovies.bind {[weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

//MARK: - Networking
    private func fetchUpcomingMovies() {
        Task {
            try await viewModel.fetchUpcomingMovies()
        }
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.upcomingMovies.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TitleTableViewCell.identifier,
            for: indexPath
        ) as? TitleTableViewCell,
              let model: Title = viewModel.upcomingMovies.value?[indexPath.row]
        else {return UITableViewCell()}
      
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let title = viewModel.upcomingMovies.value?[indexPath.row] else {return}
        
        Task {
            guard let model = try await UpcomingViewModel.fetchMovie(title: title) else {return}
            coordinator?.presentPreview(sender: self, model: model)
        }
    }
}
