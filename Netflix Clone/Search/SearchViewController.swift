//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 4/27/22.
//

import UIKit

//Shows the top results after user clicks on the Search tab
class SearchViewController: UIViewController {

//MARK: - Properties
    weak var coordinator: SearchCoordinator?
    private var viewModel = SearchViewModel()
    

//MARK: - Subviews
    private let tableView: UITableView = {
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
    
//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavBar()
        configureSubViews()
        updateUI()
        fetchDiscoverMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
//MARK: - Configure
    private func configureNavBar() {
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func configureSubViews() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchResultsUpdater = self
    }
    
    private func updateUI() {
        viewModel.discoverMovies.bind {[weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
//MARK: - Networking
    private func fetchDiscoverMovies() {
        Task {
            try await viewModel.fetchDiscoverMovies()
        }
    }
}

//MARK: - TableView Methods
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.discoverMovies.value?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell,
              let model = viewModel.discoverMovies.value?[indexPath.row]
        else {return UITableViewCell()}
        
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let title = viewModel.discoverMovies.value?[indexPath.row] else {return}
        
        Task {
            guard let model = try await SearchViewModel.fetchMovie(title: title) else {return}
            coordinator?.presentPreview(sender: self, model: model)
        }
    }
}

//MARK: - SearchResults Methods
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
    
    func SearchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            self?.coordinator?.presentPreview(sender: strongSelf, model: viewModel)
        }
    }
}
