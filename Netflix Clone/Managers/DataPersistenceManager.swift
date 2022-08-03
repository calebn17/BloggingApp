//
//  DataPersistenceManager.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 5/5/22.
//

import Foundation
import UIKit
import CoreData


class DataPersistenceManager {
    
    enum DatabaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = DataPersistenceManager()
    
    func downloadTitle(model: Title) async throws {
        guard let appDelegate = await UIApplication.shared.delegate as? AppDelegate else {return}
        let context = await appDelegate.persistentContainer.viewContext
        let item = TitleItem(context: context)
        
        item.original_title = model.original_title
        item.id = Int64(model.id)
        item.original_name = model.original_name
        item.overview = model.overview
        item.media_type = model.media_type
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average
        
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchingTitlesFromDataBase() async throws -> [TitleItem] {
        guard let appDelegate = await UIApplication.shared.delegate as? AppDelegate else {return []}
        
        let context = await appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        do {
            let titles = try context.fetch(request)
            return titles
        }
        catch {
            print("Error when fetching data from local DB")
            return []
        }
    }
    
    func deleteTitleWith(model: TitleItem) async throws {
        guard let appDelegate = await UIApplication.shared.delegate as? AppDelegate else {return}
        let context = await appDelegate.persistentContainer.viewContext
        context.delete(model)
        do{
            try context.save()
        }
        catch {
            print("Error when deleting downloaded content")
            }
    }
}
