//
//  DatabaseManager.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 7/31/22.
//

import Foundation
import FirebaseFirestore

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let firestore = Firestore.firestore()
    private var userRef: CollectionReference {
        return firestore.collection("users")
    }
//    public var currentUser: User {
//        return
//    }
    
    private init() {}
    
//MARK: - User
    func insertUser(user: User) async throws {
        guard let data = user.asDictionary() else {return}
        try await userRef.document(user.username).setData(data)
    }
    
    func getUser(username: String) async throws -> User? {
        guard let data = try await userRef.document(username).getDocument().data() else {return nil}
        guard let user = User(with: data) else {return nil}
        return user
    }
    
    func getUser(email: String) async throws -> User? {
        let users = try await userRef.getDocuments().documents.compactMap({ User(with: $0.data())})
        let user = users.first(where: {$0.email == email})
        return user
    }
}
