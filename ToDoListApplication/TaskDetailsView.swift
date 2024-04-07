//
//  TaskDetailsView.swift
//  ToDoListApplication
//
//  Created by Dhai Alassaf on 28/09/1445 AH.
//

import SwiftUI

struct TaskDetailsView: View {
    @ObservedObject var item: Task
    @State private var showingEditTaskView = false
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
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

#Preview {
    TaskDetailsView(item: Task())
}
