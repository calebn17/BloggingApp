//
//  UpcomingViewModel.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 7/29/22.
//

import Foundation

struct UpcomingViewModel {
    
    @MainActor var upcomingMovies = Observable<[Title]>([])
    
    @MainActor func fetchUpcomingMovies() async throws {
        let result = try await APICaller.shared.getUpcomingMovies()
        upcomingMovies.value = result
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
}
