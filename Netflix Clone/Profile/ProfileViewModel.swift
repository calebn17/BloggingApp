//
//  ProfileViewModel.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 8/2/22.
//

import Foundation
import UIKit

struct ProfileModel {
    let symbolString: String?
    let label: String
}

struct ProfileViewModel {
    
    var currentUser: User { return DatabaseManager.shared.currentUser }
    
    static let models: [ProfileModel] = [
        ProfileModel(symbolString: "checkmark", label: "My List"),
        ProfileModel(symbolString: "gearshape", label: "App Settings"),
        ProfileModel(symbolString: "person", label: "Account"),
        ProfileModel(symbolString: "questionmark.circle", label: "Help"),
        ProfileModel(symbolString: nil, label: "Sign Out")
    ]
    
    static func uploadProfilePicture(user: User, data: Data?) async throws {
        try await StorageManager.shared.uploadProfilePicture(username: user.username.lowercased(), data: data)
    }
    
    static func getProfilePicture(user: User) async throws -> URL? {
        let url = try await StorageManager.shared.downloadProfilePicture(username: user.username)
        return url
    }
}
