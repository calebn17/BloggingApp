//
//  SearchViewModel.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 7/29/22.
//

import Foundation

struct SearchViewModel {
    
    static func fetchDiscoverMovies() async throws -> [Title] {
        let result = try await APICaller.shared.getDiscoverMovies()
        return result
    }
}
