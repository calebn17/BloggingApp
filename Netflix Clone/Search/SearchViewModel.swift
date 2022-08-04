//
//  SearchViewModel.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 7/29/22.
//

import Foundation

struct SearchViewModel {
    
    var discoverMovies = Observable<[Title]>([])
    
    func fetchDiscoverMovies() async throws {
        let result = try await APICaller.shared.getDiscoverMovies()
        discoverMovies.value = result
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
    
    static func search(with query: String) async throws -> [Title] {
        let result = try await APICaller.shared.search(with: query)
        return result
    }
}
