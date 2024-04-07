//
//  DataController.swift
//  ToDoListApplication
//
//  Created by Dhai Alassaf on 28/09/1445 AH.
//

import CoreData

class DataController {
    static let shared = DataController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "TasksDataModel") // Use your `.xcdatamodeld` file name
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}


