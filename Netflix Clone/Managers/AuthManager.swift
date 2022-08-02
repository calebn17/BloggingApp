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
        guard let username = Auth.auth().currentUser?.email else {return true}
        print("username: \(username)")
        return Auth.auth().currentUser == nil
    }
    
    public func registerUser(user: User) async throws {
        try await Auth.auth().createUser(withEmail: user.email, password: user.password)
        try await DatabaseManager.shared.insertUser(user: user)
        UserDefaults.standard.set(user.username, forKey: K.username)
        UserDefaults.standard.set(user.email, forKey: K.email)
        UserDefaults.standard.set(user.password, forKey: K.password)
    }
    
    public func loginUser(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
        guard let user = try await DatabaseManager.shared.getUser(email: email) else {return}
        UserDefaults.standard.set(user.username, forKey: K.username)
        UserDefaults.standard.set(user.email, forKey: K.email)
        UserDefaults.standard.set(user.password, forKey: K.password)
    }
    
    public func logOut() async throws {
        try Auth.auth().signOut()
    }
}
