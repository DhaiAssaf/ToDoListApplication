//
//  DataController.swift
//  ToDoListApplication
//
//  Created by Dhai Alassaf on 28/09/1445 AH.
//

import CoreData

// Manages Core Data stack for the application.
class DataController {
    // Singleton instance to ensure one consistent data controller throughout the app.
    static let shared = DataController()
    
    // The main Core Data container handling the model, context, and store.
    let container: NSPersistentContainer
    
    init() {
        // Initializes the container with the name of the Core Data model.
        container = NSPersistentContainer(name: "TasksDataModel")
        
        // Loads the data store(s) and handles loading errors.
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // Fatal error for development phase; replace with appropriate handling for production.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}



