//
//  DownloadsViewModel.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 7/29/22.
//

import Foundation

struct DownloadsViewModel {
    
    static func fetchMovie(title: TitleItem) async throws -> TitlePreviewModel? {
        guard let titleName = title.original_name ?? title.original_title else {return nil}
        
        guard let videoElement = try await APICaller.shared.getMovie(with: titleName) else {return nil}
        
        return TitlePreviewModel(
            title: titleName,
            youtubeVideo: videoElement,
            titleOverview: title.overview ?? ""
        )
    }
    
    static func fetchDownloadedTitles() async throws -> [TitleItem] {
        let result = try await DataPersistenceManager.shared.fetchingTitlesFromDataBase()
        return result
    }
    
    static func deleteTitle(with model: TitleItem) async {
        do {
            try await DataPersistenceManager.shared.deleteTitleWith(model: model)
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
