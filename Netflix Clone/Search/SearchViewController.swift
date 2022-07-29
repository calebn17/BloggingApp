//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 4/27/22.
//

import UIKit

//Shows the top results after user clicks on the Search tab
class SearchViewController: UIViewController {
    
    weak var coordinator: SearchCoordinator?
    
    private var titles: [Title] = []

    private let discoverTable: UITableView = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
    }()
    
    private let searchController: UISearchController = {
        let search = UISearchController(searchResultsController: SearchResultsViewController())
        search.searchBar.placeholder = "Search for a Movie or a TV Show"
        search.searchBar.searchBarStyle = .minimal
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .label
        
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        updateDiscoverMoviesUI()
        
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    private func updateDiscoverMoviesUI() {
        Task {
            let titles = try await SearchViewModel.fetchDiscoverMovies()
            self.titles = titles
            discoverTable.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell
        else {return UITableViewCell()}
        
        let title = titles[indexPath.row].original_title ?? titles[indexPath.row].original_name ?? "Unknown"
        let poster = titles[indexPath.row].poster_path ?? ""
        cell.configure(with: TitleModel(titleName: title, posterURL: poster))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        Task {
            guard let model = try await SearchViewModel.fetchMovie(title: title) else {return}
            coordinator?.tappedOnSearchCell(sender: self, model: model)
        }
    }
}

extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
                !query.trimmingCharacters(in: .whitespaces).isEmpty,
                query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController
        else {return}
        
        resultsController.delegate = self
        Task {
            let titles = try await SearchViewModel.search(with: query)
            resultsController.titles = titles
            resultsController.searchResultsCollectionView.reloadData()
        }
    }
    
    func SearchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewModel) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            self?.coordinator?.tappedOnSearchCell(sender: strongSelf, model: viewModel)
        }
    }
}
