//
//  AddNewTaskView.swift
//  ToDoListApplication
//
//  Created by Dhai Alassaf on 28/09/1445 AH.
//


import SwiftUI

//Task priority
enum TaskPriority: String, CaseIterable, Identifiable {
    case high = "High" //red
    case medium = "Medium" //yellow
    case low = "Low" //green
    
    var id: String { self.rawValue }
    
}


struct AddNewTaskView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    @Binding var isShowingAddNewTaskView: Bool
    //task details
    @State private var taskTitle: String = ""
    @State private var taskDetails: String = ""
    @State private var dueDate: Date = Date()
    @State private var taskPriority: TaskPriority = .medium
    @State private var showingError = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Add Task Details"), footer: Text(showingError ? "Title must be filled in" : "Title your task to spotlight your priorities.")
                    .foregroundStyle(showingError ? .red : .gray)) {
                        TextField("Title", text: $taskTitle)
                        TextField("Details", text: $taskDetails)
                        
                        HStack {
                            
                            Picker("Priority", selection: $taskPriority) {
                                ForEach(TaskPriority.allCases) { priority in
                                    
                                    Text(priority.rawValue)
                                        .tag(priority)
                                    
                                    
                                }
                                
                            }
                            .pickerStyle(MenuPickerStyle())
                            
                        }
                    }
                
                Section(header: Text("Task Due date")){
                    
                    DatePicker("Date", selection: $dueDate, in: Date()...)
                }
                
                
                
                Section() {
                    Button("Add Task") {
                        if !taskTitle.isEmpty {
                            addNewTask()
                            dismiss()
                        } else {
                            showingError = true
                        }
                    } .frame(maxWidth: .infinity)
                    
                }
                
            }
            
            .navigationTitle("Add Task")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    
    
    private func addNewTask() {
        //create new task
        let newItem = Task(context: viewContext)
        //add task details
        newItem.title = taskTitle
        newItem.details = taskDetails
        newItem.dueDate = dueDate
        newItem.priority = taskPriority.rawValue
        newItem.isDone = false
        newItem.createdDate = Date()
        newItem.id = UUID()
        
        do {
            try viewContext.save() //save changes
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
        }
    }
}


#Preview {
    AddNewTaskView(isShowingAddNewTaskView: .constant(false))
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
