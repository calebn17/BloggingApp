//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 5/2/22.
//

import Foundation


extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
