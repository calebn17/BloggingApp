//
//  UpcomingViewModel.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 7/29/22.
//

import Foundation

struct UpcomingViewModel {
    
    static func fetchUpcomingMovies() async throws -> [Title] {
        let result = try await APICaller.shared.getUpcomingMovies()
        return result
    }
    
    static func fetchMovie(title: Title) async throws -> TitlePreviewModel? {
        guard let titleName = title.original_name ?? title.original_title else {return nil}
        guard let videoElement = try await APICaller.shared.getMovie(with: titleName) else {return nil}
        return TitlePreviewModel(
            title: titleName,
            youtubeVideo: videoElement,
            titleOverview: title.overview ?? ""
        )
    }
}
