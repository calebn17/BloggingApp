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
    
//    public func loginUser(
//        email: String,
//        password: String,
//        completion: @escaping ((Bool) -> Void)) {
//
//            Auth.auth().signIn(withEmail: email, password: password) {
//
//                authResult, error in
//                guard authResult != nil, error == nil else {
//                    //failed to login
//                    completion(false)
//                    return
//                }
//                Task {
//                    do {
//                        guard let user = try await DatabaseManager.shared.getUser(email: email) else {
//                            completion(false)
//                            return
//                        }
//                        UserDefaults.standard.set(user.userName, forKey: Cache.username)
//                        UserDefaults.standard.set(user.userHandle, forKey: Cache.userHandle)
//                        UserDefaults.standard.set(email, forKey: Cache.email)
//                        print("\nLogging in, saving credentials. username: \(user.userName)")
//                        completion(true)
//                    }
//                    catch {
//                        print("Error when retrieving username and handle")
//                    }
//                }
//            }
//        }
}
