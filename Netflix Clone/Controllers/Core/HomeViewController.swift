//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 4/27/22.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTV = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

//Home Tab
class HomeViewController: UIViewController {

//MARK: - Setup
    
    private var randomTrendingMovie: Title?
    
    let sectionTitles: [String] = ["Trending Movies", "Trending TV", "Popular", "Upcoming Movies", "Top Rated"]
    
//    private var trendingMovies: [Title] = []
//    private var tvs: [Title] = []
//    private var upcomingMovies: [Title] = []
//    private var popular: [Title] = []
//    private var topRated: [Title] = []
    
    private let homeFeedTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return tableView
    }()
    
//MARK: - Load View Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        view.addSubview(homeFeedTableView)
        homeFeedTableView.delegate = self
        homeFeedTableView.dataSource = self
        
        configureNavbar()
        
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTableView.tableHeaderView = headerView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        homeFeedTableView.frame = view.bounds
    }
    

//MARK: - Actions
    
    private func configureNavbar() {
        var image = UIImage(named: "netflixLogo")
        image?.accessibilityFrame = CGRect(x: 0, y: 0, width: 20, height: 20)
        //forces xcode to use the original image (logo comes out as different color if this isnt done)
        image = image?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
   
}

//MARK: - UITable Methods

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {return UITableViewCell()}
        
        //need to set the delegate here because the cell is defined here in the Home VC. Home VC is the delegate for the cell (a CollectionViewTableViewCell)
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                        switch result {
                        case .success(let movies):
                            cell.configure(with: movies)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
        case Sections.TrendingTV.rawValue:
            APICaller.shared.getTrendingTV { result in
                        switch result {
                        case .success(let tv):
                            cell.configure(with: tv)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
        case Sections.Popular.rawValue:
            APICaller.shared.getPopular { result in
                        switch result {
                        case .success(let movies):
                            cell.configure(with: movies)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                        switch result {
                        case .success(let movies):
                            cell.configure(with: movies)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRated { result in
                        switch result {
                        case .success(let movies):
                            cell.configure(with: movies)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
            
        default:
            return UITableViewCell()
        }
        
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
        header.textLabel?.textColor = .white
        //header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
//    //Hides the navBar as the user scrolls down (navigates down the page)
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let defaultOffset = view.safeAreaInsets.top
//        let offset = scrollView.contentOffset.y + defaultOffset
//
//        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
//    }
//
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

