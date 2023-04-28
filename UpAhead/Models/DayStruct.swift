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
        var height: CGFloat = events.count <= 1 ? 200 : CGFloat((events.count * 100) + 100)
        if editMode && events.count != 0 {
            height += 100
        }
        return height
    }
    
    var completedEventsCount: Int {
        return events.filter({ $0.isCompleted }).count
    }
    
    var uncompletedEventsCount: Int {
        return events.filter({ !$0.isCompleted }).count
    }
    
    var isCompleted: Bool {
        return completedEventsCount == events.count
    }
    
    var completionPercent: Double {
        if events.count != 0 {
            return Double(completedEventsCount) / Double(events.count) * 100.0
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
        var event = Event(title: event.title, date: event.date, iconName: event.iconName, color: event.color, isCompleted: event.isCompleted)
        event.setIndex(events.count)
        events.append(event)
    }
    
    mutating func deleteEvent(index: Int) {
        events.remove(at: index)
    }
    
    mutating func deleteEvent(_ event: Event) {
        if let index = events.firstIndex(where: { $0 == event }) {
            events.remove(at: index)
        }
    }
    
    mutating func reorganizeEvents() {
        events.sort { $0.isCompleted == false && $1.isCompleted == true }
    }
    
    mutating func nextEvent() {
        if !isCompleted {
            let index = events.count - completedEventsCount - 1
            events[index].isCompleted = true
        }
    }
    
    mutating func previousEvent() {
        if completedEventsCount != 0 {
            let index = events.count - completedEventsCount
            events[index].isCompleted = false
        }
    }
    
    mutating func toggleEditMode(state: Bool? = nil) {
        if let state = state {
            self.editMode = state
        } else {
            self.editMode.toggle()
        }
    }
}

struct Event: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    
    // UI data
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
    
    let event1 = Event(title: "Meeting with Client A", date: randomDateInLast24Hours(), iconName: "briefcase.fill", color: .blue, isCompleted: false)
    let event2 = Event(title: "Lunch with Colleagues", date: randomDateInLast24Hours(), iconName: "cart.fill", color: .green, isCompleted: false)
    let event3 = Event(title: "Fitness Class", date: randomDateInLast24Hours(), iconName: "figure.walk.circle.fill", color: .orange, isCompleted: false)
    
    let events: [Event] = [event1, event2, event3]
    
    var eventArray: [Event] = []
    
    for i in 0..<amount {
        eventArray.append(events[i % 3])
    }
    
    return eventArray
}

func randomDateInLast24Hours() -> Date {
    let hoursInDay = 24
    let secondsInHour = 3600
    
    let randomNumber = Int.random(in: 1...hoursInDay * secondsInHour)
    let randomTimeInterval = TimeInterval(randomNumber)
    
    let now = Date()
    let randomDate = now - randomTimeInterval
    
    return randomDate
}

func defaultDate() -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let dateString = "2000-01-01 00:00:00"
    let defaultDate = formatter.date(from: dateString)!
    return defaultDate
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
