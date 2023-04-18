//
//  DayStruct.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-06.
//

import SwiftUI

struct Day {
    let date: Date
    let weekDay: WeekDay
    var events: [Event]
    var editMode: Bool = false
    
    var height: CGFloat {
        return events.count <= 1 ? 200 : CGFloat((events.count * 100) + 100)
    }
    
    var completedEvent: Int {
        return events.filter({ $0.isCompleted }).count
    }
    
    var dayCompleted: Bool {
        return completedEvent == events.count
    }
    
    var completionPourcent: Double {
        if events.count != 0 {
            return Double(completedEvent) / Double(events.count) * 100.0
        } else {
            return 0
        }
    }
    
    init(date: Date, events: [Event]) {
        self.date = date
        self.weekDay = WeekDay.fromString(date.weekday) ?? .monday
        self.events = []
        for event in events {
            self.addEvent(event)
        }
    }
    
    mutating func addEvent(_ event: Event) {
        var event = Event(title: event.title, iconName: event.iconName, color: event.color, isCompleted: event.isCompleted)
        event.setIndex(events.count)
        events.append(event)
    }
    
    mutating func deleteEvent(index: Int) {
        events.remove(at: index)
    }
    
    mutating func reorganizeEvents() {
        events.sort { $0.isCompleted == false && $1.isCompleted == true }
    }
    
    mutating func toggleEditMode(state: Bool? = nil) {
        if state == nil {
            if editMode {
                if !events.isEmpty {
                    events.removeLast()
                }
            } else {
                events.append(Event(title: "AddBox", iconName: "", color: .gray, isCompleted: false, index: events.count))
            }
            editMode.toggle()
        } else if state != nil && editMode != state {
            if state == false {
                if !events.isEmpty {
                    events.removeLast()
                }
            } else {
                events.append(Event(title: "AddBox", iconName: "", color: .gray, isCompleted: false, index: events.count))
            }
            editMode.toggle()
        }
        
    }
}

struct Event: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
    let color: Color
    var isCompleted: Bool
    private(set) var index: Int = 0
    
    mutating func toggleComplete() {
        self.isCompleted.toggle()
    }
    
    mutating func setIndex(_ index: Int) {
        self.index = index
    }
}

func getEvents(amount: Int) -> [Event] {
    let event1 = Event(title: "Meeting with Client A", iconName: "briefcase.fill", color: .blue, isCompleted: false)
    let event2 = Event(title: "Lunch with Colleagues", iconName: "cart.fill", color: .green, isCompleted: true)
    let event3 = Event(title: "Fitness Class", iconName: "figure.walk.circle.fill", color: .orange, isCompleted: false)
    
    let events: [Event] = [event1, event2, event3]
    
    var eventArray: [Event] = []
    
    for i in 0..<amount {
        eventArray.append(events[i % 3])
    }
    
    return eventArray
}

func getProjects(for date: Date) -> [String] {
    // Generate a random list of project strings
    let numProjects = Int.random(in: 0..<5)
    var projects = [String]()
    for _ in 0..<numProjects {
        projects.append("Project \(projects.count + 1)")
    }
    return projects
}
