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
    
    static func isNotAuthenticated() -> Bool {
        return AuthManager.shared.isNotAuthenticated()
    }
    
    static func fetchTrendingMovies() async throws -> [Title] {
        let result = try await APICaller.shared.getTrendingMovies()
        return result
    }
    
    static func fetchTrendingTv() async throws -> [Title] {
        let result = try await APICaller.shared.getTrendingTV()
        return result
    }
    
    static func fetchUpcomingMovies() async throws -> [Title] {
        let result = try await APICaller.shared.getUpcomingMovies()
        return result
    }
    
    static func fetchPopular() async throws -> [Title] {
        let result = try await APICaller.shared.getPopular()
        return result
    }
    
    static func fetchTopRated() async throws -> [Title] {
        let result = try await APICaller.shared.getTopRated()
        return result
    }
    
    
}
