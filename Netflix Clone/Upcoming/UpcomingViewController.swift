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
    
    private let upcomingTable: UITableView = {
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
        
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        updateUpcomingUI()
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func updateUpcomingUI() {
        Task {
            let titles = try await UpcomingViewModel.fetchUpcomingMovies()
            self.titles = titles
            upcomingTable.reloadData()
        }
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell
        else {return UITableViewCell()}
        
        let title = titles[indexPath.row].original_title ?? titles[indexPath.row].original_name ?? "Unknown"
        let poster = titles[indexPath.row].poster_path ?? ""
        cell.configure(with: TitleModel(titleName: title , posterURL: poster))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        Task {
            guard let model = try await UpcomingViewModel.fetchMovie(title: title) else {return}
            coordinator?.tappedCell(sender: self, model: model)
        }
    }
}
