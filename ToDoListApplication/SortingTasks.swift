//
//  SortingTasks.swift
//  ToDoListApplication
//
//  Created by Dhai Alassaf on 28/09/1445 AH.
//


import Foundation

//Sorting type
    enum SortingType: String, CaseIterable, Identifiable {
        case defaultSorting = "No Filter"
        case dueDate = "Due Date"
        case new = "New"
        case done = "Done"
        case priority = "Priority"

        var id: String { rawValue }
        
        var systemImageName: String {
            switch self {
            case .dueDate: return "calendar.badge.clock"
            case .done: return "calendar.badge.checkmark"
            case .new: return "calendar"
            case .priority: return "calendar.badge.exclamationmark"
            default: return "questionmark"
            }
        }
    }
class SortingTasks {

    static func SortItems(_ items: [Task], with sort: SortingType) -> [Task] {
        switch sort {
        case .defaultSorting:
            return items.sorted {
                if $0.isDone != $1.isDone {
                    return $0.isDone
                } else {
                    // If both have the same status, then sort by dueDate
                    return ($0.dueDate ?? Date()) < ($1.dueDate ?? Date())
                }
            }
        case .dueDate:
            // Sort items by due date
            return items.filter { $0.dueDate != nil }.sorted { $0.dueDate! < $1.dueDate! }
        case .new:
            // Sort items by created date in descending order
            return items.filter { $0.createdDate != nil }
                        .sorted { $0.createdDate! > $1.createdDate! }
        case .done:
            // First, filter items to only include those that are done
            let doneItems = items.filter { $0.isDone }
            // Sort done items by created date in descending order (new to old)
            let sortedDoneItems = doneItems.sorted { $0.createdDate! > $1.createdDate! }
            // Filter items to only include those that are not done
            let notDoneItems = items.filter { !$0.isDone }
            // Combine sorted done items with not done items
            return sortedDoneItems + notDoneItems
        case .priority:
            // Sort items by priority
            return items.sorted { item1, item2 in
                let priorities = ["Low": 1, "Medium": 2, "High": 3]
                return priorities[item1.priority ?? "", default: 0] > priorities[item2.priority ?? "", default: 0]
            }
        }
    }
}
