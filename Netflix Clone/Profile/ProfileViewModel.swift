//
//  ProfileViewModel.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 8/2/22.
//

import Foundation
import UIKit

struct ProfileTableViewModel {
    let symbolString: String?
    let label: String
}

struct ProfilePictureViewModel {
    var pictureUrl: URL?
}

struct ProfileViewModel {
    
    @MainActor var profilePicture: Observable<ProfilePictureViewModel> = Observable(ProfilePictureViewModel(pictureUrl: nil))
    
    var currentUser: User { return DatabaseManager.shared.currentUser }
    
    let tableViewModels: [ProfileTableViewModel] = [
        ProfileTableViewModel(symbolString: "checkmark", label: "My List"),
        ProfileTableViewModel(symbolString: "gearshape", label: "App Settings"),
        ProfileTableViewModel(symbolString: "person", label: "Account"),
        ProfileTableViewModel(symbolString: "questionmark.circle", label: "Help"),
        ProfileTableViewModel(symbolString: nil, label: "Sign Out")
    ]
    
    @MainActor func getProfilePicture(user: User) async throws {
        let url = try await StorageManager.shared.downloadProfilePicture(username: user.username)
        profilePicture.value?.pictureUrl = url
    }
    
    static func uploadProfilePicture(user: User, data: Data?) async throws {
        try await StorageManager.shared.uploadProfilePicture(username: user.username.lowercased(), data: data)
    }
}
