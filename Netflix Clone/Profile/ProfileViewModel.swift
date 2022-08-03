//
//  ProfileViewModel.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 8/2/22.
//

import Foundation

struct ProfileModel {
    let symbolString: String?
    let label: String
}

struct ProfileViewModel {
    
    static let models: [ProfileModel] = [
        ProfileModel(symbolString: "checkmark", label: "My List"),
        ProfileModel(symbolString: "gearshape", label: "App Settings"),
        ProfileModel(symbolString: "person", label: "Account"),
        ProfileModel(symbolString: "questionmark.circle", label: "Help"),
        ProfileModel(symbolString: nil, label: "Sign Out")
    ]
}
