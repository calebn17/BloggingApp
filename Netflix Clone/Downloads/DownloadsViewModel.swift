//
//  DownloadsViewModel.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 7/29/22.
//

import Foundation

struct DownloadsViewModel {
    
    var downloadedTitles = Observable<[TitleItem]>([])
    
    static func fetchMovie(title: TitleItem) async throws -> TitlePreviewViewModel? {
        guard let titleName = title.original_name ?? title.original_title else {return nil}
        
        guard let videoElement = try await APICaller.shared.getMovie(with: titleName) else {return nil}
        
        return TitlePreviewViewModel(
            title: titleName,
            youtubeVideo: videoElement,
            titleOverview: title.overview ?? ""
        )
    }
    
    func fetchDownloadedTitles() async throws {
        let result = try await DataPersistenceManager.shared.fetchingTitlesFromDataBase()
        downloadedTitles.value = result
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
