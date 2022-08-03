//
//  StorageManager.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 8/2/22.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    let storage = Storage.storage().reference()
    static let shared = StorageManager()
    private init() {}
    
    func uploadProfilePicture(username: String, data: Data?) async throws {
        guard let data = data else {return}
        let _ = try await storage.child("\(username)/profile_picture.png").putDataAsync(data, metadata: nil)
    }

    func downloadProfilePicture(username: String) async throws -> URL? {
        let url = try await storage.child("\(username)/profile_picture_png").downloadURL()
        print(String(describing: url))
        return url
    }
}
