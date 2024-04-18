//
//  TaskDetailsView.swift
//  ToDoListApplication
//
//  Created by Dhai Alassaf on 28/09/1445 AH.
//

import SwiftUI

struct TaskDetailsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var item: Task //so edits will be refreshed right away
    @State private var showingEditTaskView = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text(item.details ?? "No details")
                    .font(.title2)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                Button(action: {
                    showingEditTaskView = true
                }) {
                    
                    Text("Edit Task")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 40)
                        .background(.blue)
                        .cornerRadius(10)
                }
                
                .padding()
                
                //edit task sheet
                .sheet(isPresented: $showingEditTaskView) {
                    EditTaskView(todoItems: item)
                } .padding()
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitle(item.title ?? "Title", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .padding()
                }
            }
        }
    }
}
