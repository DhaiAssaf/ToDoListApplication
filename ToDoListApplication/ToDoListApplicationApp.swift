//
//  ToDoListApplicationApp.swift
//  ToDoListApplication
//
//  Created by Dhai Alassaf on 28/09/1445 AH.
//

import SwiftUI
import CoreData

@main
struct ToDoListApplicationApp: App {
    let dataController = DataController.shared
        var body: some Scene {
            WindowGroup {
                ContentView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    
            }
        }
}
