//
//  HomeViewModel.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 7/29/22.
//

import Foundation

enum HomeSections: Int {
    case TrendingMovies = 0
    case TrendingTV = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

struct HomeViewModel {
    
    static let sectionTitles = ["Trending Movies", "Trending TV", "Popular", "Upcoming Movies", "Top Rated"]
    
    var isNotAuthenticated: Bool {
        return AuthManager.shared.isNotAuthenticated()
    }
    var titles: [ Observable<[Title]> ] = []
    
    var trendingMovies = Observable<[Title]>([])
    var trendingTV = Observable<[Title]>([])
    var upcomingMovies = Observable<[Title]>([])
    var popular = Observable<[Title]>([])
    var topRated = Observable<[Title]>([])
    var heroHeaderModel: Observable<Title> = Observable(nil)
    
    func fetchTrendingMovies() async throws {
        let result = try await APICaller.shared.getTrendingMovies()
        trendingMovies.value = result
    }
    
    func fetchTrendingTv() async throws {
        let result = try await APICaller.shared.getTrendingTV()
        trendingTV.value = result
    }
    
    func fetchUpcomingMovies() async throws {
        let result = try await APICaller.shared.getUpcomingMovies()
        upcomingMovies.value = result
    }
    
    func fetchPopular() async throws {
        let result = try await APICaller.shared.getPopular()
        popular.value = result
    }
    
    func fetchTopRated() async throws {
        let result = try await APICaller.shared.getTopRated()
        topRated.value = result
    }
    
    func fetchHeroHeaderModel() async throws {
        let titles = try await APICaller.shared.getTrendingMovies()
        guard let poster = titles.randomElement() else {return}
        heroHeaderModel.value = poster
    }
    
    func fetchAllData() {
        Task {
            try await fetchTrendingMovies()
            try await fetchTrendingTv()
            try await fetchUpcomingMovies()
            try await fetchPopular()
            try await fetchTopRated()
            try await fetchHeroHeaderModel()
        }
    }
    
    static func fetchMovie(title: Title) async throws -> TitlePreviewViewModel? {
        guard let titleName = title.original_name ?? title.original_title else {return nil}
        guard let videoElement = try await APICaller.shared.getMovie(with: titleName) else {return nil}
        return TitlePreviewViewModel(
            title: titleName,
            youtubeVideo: videoElement,
            titleOverview: title.overview ?? ""
        )
    }
    
    static func downloadTitle(title: Title) async throws {
        try await DataPersistenceManager.shared.downloadTitle(model: title)
        NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
    }
    
}
