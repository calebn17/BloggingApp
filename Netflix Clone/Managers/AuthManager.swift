//
//  AuthManager.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 7/31/22.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    static let shared = AuthManager()
    private init() {}
    
    func isNotAuthenticated() -> Bool {
        return Auth.auth().currentUser == nil
    }
}
