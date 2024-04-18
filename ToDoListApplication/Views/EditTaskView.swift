//
//  EditTaskView.swift
//  ToDoListApplication
//
//  Created by Dhai Alassaf on 28/09/1445 AH.
//

import SwiftUI
import CoreData

struct EditTaskView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
    // Task item to edit
    var todoItems: FetchedResults<Task>.Element
    
    //Attributes to edit
    @State private var showingError = false
    @State private var taskTitle: String = ""
    @State private var taskDetails: String = ""
    @State private var dueDate: Date = Date()
    @State private var taskPriority: String = ""
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                Section(header: Text("Task Details"), footer: Text(showingError ? "Title must be filled in!" : "You can edit your task details") //user must input a title
                    .foregroundStyle(showingError ? .red : .gray))  {
                        TextField("Task Title", text: $taskTitle)
                        TextField("Task Details", text: $taskDetails)
                        Picker("Priority", selection: $taskPriority) {
                            ForEach(TaskPriority.allCases, id: \.self) { priority in
                                Text(priority.rawValue).tag(priority.rawValue)
                            }
                        }
                    }
                Section(header: Text("Task due date")){
                    DatePicker("Date", selection: $dueDate)
                }
                
                Section() {
                    Button("Save Changes") {
                        if !taskTitle.isEmpty { //check if title is not empty
                            saveEdit()
                            dismiss()
                        } else {
                            showingError = true
                        }
                    } .frame(maxWidth: .infinity)
                    
                }
            }
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
        }
        
        .onAppear{ //retrive task details
            
            taskTitle = todoItems.title ?? ""
            taskDetails = todoItems.details ?? ""
            dueDate = todoItems.dueDate ?? Date()
            taskPriority = todoItems.priority ?? ""
            
        }
        
    }
    
    func saveEdit() {
        todoItems.title = taskTitle
        todoItems.details = taskDetails
        todoItems.dueDate = dueDate
        todoItems.priority = taskPriority
        
        try? viewContext.save()
    }
}
