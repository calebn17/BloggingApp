//
//  OnboardingViewModel.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 8/1/22.
//

import Foundation
import UIKit

struct OnboardingViewModel { 
    
    static func register(username: String, email: String, password: String) async throws {
        let user = User(
            username: username.lowercased(),
            email: email.lowercased(),
            password: password.lowercased()
        )
        try await AuthManager.shared.registerUser(user: user)
    }
    
    static func signIn(email: String, password: String) async throws {
        try await AuthManager.shared.loginUser(email: email.lowercased(), password: password.lowercased())
    }
    
    static func uploadProfilePicture(username: String, data: Data?) async throws {
        try await StorageManager.shared.uploadProfilePicture(username: username.lowercased(), data: data)
    }
}
