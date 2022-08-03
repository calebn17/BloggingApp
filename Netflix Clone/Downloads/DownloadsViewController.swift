//
//  DownloadsViewController.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 4/27/22.
//

import UIKit

class DownloadsViewController: UIViewController {
    weak var coordinator: DownloadsCoordinator?
    private var titles: [TitleItem] = []

    private let downloadedTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        downloadedTable.delegate = self
        downloadedTable.dataSource = self
        view.addSubview(downloadedTable)
        
        navigationController?.navigationBar.tintColor = .white
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { [weak self] _ in
            self?.fetchLocalStorageForDownload()
        }
        
        fetchLocalStorageForDownload()
    }
    
    override func viewDidLayoutSubviews() {
        downloadedTable.frame = view.bounds
    }
    
    private func fetchLocalStorageForDownload() {
        Task {
            self.titles = try await DownloadsViewModel.fetchDownloadedTitles()
            downloadedTable.reloadData()
        }
    }
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        Task {
            let title = titles[indexPath.row]
            guard let model = try await DownloadsViewModel.fetchMovie(title: title) else {return}
            coordinator?.presentPreview(sender: self, model: model)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            Task {
                let title = titles[indexPath.row]
                await DownloadsViewModel.deleteTitle(with: title)
                
                //remove particular title from titles array FIRST and then delete the tableView row or we will get an error
                self.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        default: break
        }
    }
}
