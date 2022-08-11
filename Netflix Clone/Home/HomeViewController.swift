//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 4/27/22.
//

import UIKit

//Home Tab
final class HomeViewController: UIViewController {

//MARK: - Properties
    weak var coordinator: HomeCoordinator?
    var viewModel = HomeViewModel()
    let sectionTitles = HomeViewModel.sectionTitles
    var isNotAuthenticated: Bool { return HomeViewModel().isNotAuthenticated }
    
//MARK: - Subviews
    private var headerView: HeroHeaderUIView?
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(HomeCollectionViewTableViewCell.self, forCellReuseIdentifier: HomeCollectionViewTableViewCell.identifier)
        return tableView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tintColor = .label
        spinner.startAnimating()
        spinner.isHidden = false
        return spinner
    }()
    
//MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        handleIfNotAuthenticated()
        configureTableView()
        configureNavbar()
        configureHeroHeaderView()
        updateUI()
        fetchData()
        handleLoadingState()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    

//MARK: - Configure
    
    private func configureNavbar() {
        var image = UIImage(named: "netflixLogo")
        image?.accessibilityFrame = CGRect(x: 0, y: 0, width: 20, height: 20)
        image = image?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: #selector(didTapProfileButton)),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func handleLoadingState() {
        view.addSubview(spinner)
        if viewModel.heroHeaderModel.value == nil {
            tableView.isHidden = true
        } else {
            spinner.stopAnimating()
            spinner.isHidden = true
            tableView.isHidden = false
        }
    }
    
    private func updateUI() {
        viewModel.heroHeaderModel.bind {[weak self] title in
            guard let title = title else {return}
            self?.handleLoadingState()
            self?.headerView?.configure(with: title)
        }
        viewModel.popular.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
        viewModel.trendingMovies.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
        viewModel.trendingTV.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
        viewModel.upcomingMovies.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    private func configureHeroHeaderView() {
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        tableView.tableHeaderView = headerView
        headerView?.delegate = self
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func handleIfNotAuthenticated() {
        if isNotAuthenticated {
            coordinator?.presentLoginScreen(sender: self)
        }
    }
    
//MARK: - Networking
    private func fetchData() {
        viewModel.fetchAllData()
    }
    
//MARK: - Actions
    @objc private func didTapProfileButton() {
        coordinator?.pushProfileScreen(sender: self)
    }
}

//MARK: - HeroHeader Methods
extension HomeViewController: HeroHeaderUIViewDelegate {
    func heroHeaderUIViewDelegateDidTapPlay(title: Title) {
        Task {
            guard let model = try await HomeViewModel.fetchMovie(title: title) else {return}
            coordinator?.presentPreview(viewModel: model, sender: self)
        }
    }
    
    func heroHeaderUIViewDelegateDidTapDownload(title: Title) {
        Task {
            try await HomeViewModel.downloadTitle(title: title)
        }
    }
}

//MARK: - TableView Methods

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HomeCollectionViewTableViewCell.identifier,
            for: indexPath
        ) as? HomeCollectionViewTableViewCell,
              let movies = viewModel.trendingMovies.value,
              let tvShows = viewModel.trendingTV.value,
              let popular = viewModel.popular.value,
              let upcoming = viewModel.upcomingMovies.value,
              let topRated = viewModel.topRated.value
        else {return UITableViewCell()}
        
        switch indexPath.section {
        case HomeSections.TrendingMovies.rawValue:  cell.configure(with: movies)
        case HomeSections.TrendingTV.rawValue:      cell.configure(with: tvShows)
        case HomeSections.Popular.rawValue:         cell.configure(with: popular)
        case HomeSections.Upcoming.rawValue:        cell.configure(with: upcoming)
        case HomeSections.TopRated.rawValue:        cell.configure(with: topRated)
        default:                                    return UITableViewCell()
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .label
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    //Hides the navBar as the user scrolls down (navigates down the page)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

//MARK: - HomeCollectionTable Cell Methods
extension HomeViewController: HomeCollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: HomeCollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            self?.coordinator?.presentPreview(viewModel: viewModel, sender: strongSelf)
        }
    }
}
