//
//  ContentView.swift
//  ToDoListApplication
//
//  Created by Dhai Alassaf on 28/09/1445 AH.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var isShowingAddNewTaskView = false
    @State private var isShowSplashScreen = true
    @State private var selectedItem: Task? = nil // State to track selected item for editing
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.title, ascending: true)],
        animation: .easeInOut(duration: 0.3)
    ) private var todoItems: FetchedResults<Task>

    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    listBody
                }
                .navigationBarTitle("To-Do List")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        addButton
                    }
                 
                }
                .sheet(isPresented: $isShowingAddNewTaskView) {
                    AddNewTaskView(isShowingAddNewTaskView: $isShowingAddNewTaskView)
                }
            }
            
            
            .sheet(item: $selectedItem) { item in
                TaskDetailsView()
            }
            
        }}
    private var listBody: some View {
        List {
            ForEach(todoItems, id: \.self) { item in
                Button(action: {
                    self.selectedItem = item // Set the selectedItem to trigger the sheet
                }) {
                    listItemContent(for: item)
                }
                .buttonStyle(PlainButtonStyle()) // So it looks like a list item, not a button
            }
            .onDelete(perform: deleteItems)
        }
    }

    private func listItemContent(for item: Task) -> some View {
        HStack {
            Circle()
                .frame(width: 10, height: 10)
                .foregroundColor(item.priority == "High" ? .red : (item.priority == "Medium" ? .yellow : .green))

            
            VStack(alignment: .leading) {
                Text(item.title ?? "Untitled").font(.headline)
                HStack {
                    Text(item.dueDate?.formatted(date: .abbreviated, time: .shortened) ?? "No date").font(.caption)
                    
                    if let dueDate = item.dueDate, dueDate < Date() {
                     
                        Text("Overdue")
                            .font(.caption)
                            .foregroundColor(.red)
                    }}
            }
            Spacer()
            statusButton(for: item)
        }
    }


    private func statusButton(for item: Task) -> some View {
        Button(action: {
            item.isDone.toggle()
            saveContext()
        }) {
            Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                .foregroundColor(item.isDone ? .green : .gray)
        }
        .buttonStyle(BorderlessButtonStyle())
    }

    private var addButton: some View {
        Button(action: {
            isShowingAddNewTaskView = true
        }) {
            Image(systemName: "plus")
                .foregroundStyle(.yellow)
                .bold()
        }
    }
    
 

    




    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { todoItems[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }



}



    
    #Preview {
        ContentView()
            .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
