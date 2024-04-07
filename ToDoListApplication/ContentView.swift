//
//  ContentView.swift
//  ToDoListApplication
//
//  Created by Dhai Alassaf on 28/09/1445 AH.
//

import SwiftUI
import CoreData


struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    @State private var isShowingAddNewTaskView = false
    @State private var isShowSplashScreen = true
    @State private var selectedItem: Task? = nil
    @State private var sortSelection: SortingType = .defaultSorting
    private var filteredItems: [Task] {
        return SortingTasks.SortItems(Array(todoItems), with: sortSelection)
    }
    
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
                    ToolbarItem(placement: .navigationBarTrailing) {
                        SortMenu
                    }
                    
                }
                .sheet(isPresented: $isShowingAddNewTaskView) {
                    AddNewTaskView(isShowingAddNewTaskView: $isShowingAddNewTaskView)
                }
            }
            
            
            .fullScreenCover(item: $selectedItem) { item in
                TaskDetailsView(item: item)
            }
            
        }}
    private var listBody: some View {
        List {
            ForEach(filteredItems, id: \.self) { item in
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
    
    
    
    
    
    private var SortMenu: some View {
       Menu {
            Picker("Sort", selection: $sortSelection) {
                ForEach(SortingType.allCases.filter { $0 != .defaultSorting }, id: \.self) { sort in
                    HStack{
                        Image(systemName: sort.systemImageName)
                            .foregroundColor(.gray)
                        Text(sort.rawValue).tag(sort)
                    }
                }
            }
        } label: {
            Label("Sort Options", systemImage: "line.horizontal.3")
                .imageScale(.large)
                .bold()
        }
    }
    }

    

    
    #Preview {
        ContentView()
            .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
