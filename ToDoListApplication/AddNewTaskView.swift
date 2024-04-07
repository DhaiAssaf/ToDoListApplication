//
//  AddNewTaskView.swift
//  ToDoListApplication
//
//  Created by Dhai Alassaf on 28/09/1445 AH.
//


import SwiftUI

enum TaskPriority: String, CaseIterable, Identifiable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"

    var id: String { self.rawValue }
    
    var color: Color {
        switch self {
        case .high: return .red
        case .medium: return .yellow
        case .low: return .green
        }
    }
}


struct AddNewTaskView: View {
    @Binding var isShowingAddNewTaskView: Bool
    @State private var taskTitle: String = ""
    @State private var taskDetails: String = ""
    @State private var dueDate: Date = Date()
    @State private var taskPriority: TaskPriority = .medium
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @State private var showingError = false
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Add Task Details"), footer: Text(showingError ? errorMessage : "Title your task to spotlight your priorities.")
                    .foregroundStyle(showingError ? .red : .gray)) {
                    TextField("Title", text: $taskTitle)
                    TextField("Details", text: $taskDetails)
                    
                    HStack {
                        
                        Picker("Priority", selection: $taskPriority) {
                            ForEach(TaskPriority.allCases) { priority in
                                
                                Text(priority.rawValue).tag(priority)
                                
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
                            checkForError()
                        }
                    } .frame(maxWidth: .infinity)
                                  
                }
                          
            }
            
            .navigationTitle("Add Task")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func checkForError() {
        if taskTitle.isEmpty {
            showingError = true
            errorMessage = "Title must be filled in!"
        } else {
            showingError = false
        }
    }
    
    private func addNewTask() {
        let newItem = Task(context: viewContext)
        newItem.title = taskTitle
        newItem.details = taskDetails
        newItem.dueDate = dueDate
        newItem.priority = taskPriority.rawValue
        newItem.isDone = false
        newItem.id = UUID()
        
        do {
            try viewContext.save()
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
