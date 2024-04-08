//
//  ContentView.swift
//  ToDoListApplication
//
//  Created by Dhai Alassaf on 28/09/1445 AH.
//

import SwiftUI
import CoreData


struct ContentView: View {
    
    //priority details
    @State private var showingPriorityMessage: Bool = false
    @State private var showingPriorityMessageForTaskID: NSManagedObjectID?
    
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss //to go back to the previous view
    
    @State private var isShowingAddNewTaskView = false
    @State private var selectedItem: Task? = nil
    @State private var sortSelection: SortingType = .defaultSorting
    //Tasks list copy
    private var sortedItems: [Task] {
        return SortingTasks.SortItems(Array(todoItems), with: sortSelection)
    }
    //Fetch request to get Tasks
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.title, ascending: true)],
        animation: .easeInOut(duration: 0.3)
    ) private var todoItems: FetchedResults<Task>
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            NavigationView {
                VStack {
                    listBody
                }
                .navigationBarTitle("To-Do List")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        SortMenu
                    }
                }
                //add new task sheet
                .sheet(isPresented: $isShowingAddNewTaskView) {
                    AddNewTaskView(isShowingAddNewTaskView: $isShowingAddNewTaskView)
                }
                //task dsecription view
                .fullScreenCover(item: $selectedItem) { item in
                    TaskDetailsView(item: item)
                }
            }
            
            addButton
                .padding(.trailing, 30) // Right padding
                .padding(.bottom, 30)
        }
    }
    
    //List view
    private var listBody: some View {
        List {
            ForEach(sortedItems, id: \.self) { item in
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
        
        
        return ZStack(alignment: .leading) {
            HStack {
                // Tappable circle for showing the priority message.
                Button(action: {
                    withAnimation {
                        // Check if the current task's message is already being shown
                        if showingPriorityMessageForTaskID == item.objectID {
                            showingPriorityMessageForTaskID = nil // If so, hide it
                        } else {
                            // Otherwise, show the message for the current task
                            showingPriorityMessageForTaskID = item.objectID
                        }
                    }
                }) {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(item.priority == "High" ? .red : (item.priority == "Medium" ? .yellow : .green))
                }
                .buttonStyle(BorderlessButtonStyle())
                
                VStack(alignment: .leading) {
                    Text(item.title ?? "Untitled")
                        .font(.headline)
                        .strikethrough(item.isDone, color: .red)
                    HStack(alignment: .top) {
                        Text(item.dueDate?.formatted(date: .abbreviated, time: .shortened) ?? "No date").font(.caption)
                    }
                }
                
                Spacer()
                
                if let dueDate = item.dueDate, dueDate < Date() {
                    Text("Overdue")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 10))
                        .background(Color(white: 0.3))
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(Color.gray, lineWidth: 1.5)
                        )
                }
                
                statusButton(for: item)
            }
            .contentShape(Rectangle()) // To ensure the entire row is tappable, not just the text and circle
            
            // Overlay priority message if showingPriorityMessage is pressed
            if showingPriorityMessageForTaskID == item.objectID {
                Text(item.priority ?? "Unknown")
                    .font(.caption)
                    .padding(5)
                    .background(Color.gray)
                    .foregroundColor(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .offset(x: 20, y: 0) // Offset from the circle
                    .transition(.opacity) // Fade in/out for the message
                    .zIndex(1) // Make sure the message overlays everything else
            }
        }
    }
    
    
    
    //Task status check button
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
    
    //Add task button
    private var addButton: some View {
        Button(action: {
            isShowingAddNewTaskView = true
        }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 45, height: 45)
                .foregroundStyle(.gray)
            
            
        }
    }
    
    //delete task function
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { todoItems[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }
    //save changes function
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    //sorting menu
    private var SortMenu: some View {
        Menu {
            Picker("Sort", selection: Binding($sortSelection, deselectTo: .defaultSorting)) {
                //default sorting will not be included in the menu
                ForEach(SortingType.allCases.filter { $0 != .defaultSorting }, id: \.self) { sort in
                    HStack {
                        Text(sort.rawValue).tag(sort)
                        Image(systemName: sort.systemImageName)
                    }
                }
            }
        } label: {
            Image(systemName: "list.bullet")
                .resizable()
                .foregroundStyle(.gray)
            
            
            
        }
    }
    
    
}

//Create Extensions on SwiftUI Binding to deselect option on Picker

public extension Binding where Value: Equatable {
    init(_ source: Binding<Value>, deselectTo value: Value) {
        self.init(get: { source.wrappedValue },
                  set: { source.wrappedValue = $0 == source.wrappedValue ? value : $0 }
        )
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
