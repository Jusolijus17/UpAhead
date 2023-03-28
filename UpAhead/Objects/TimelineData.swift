//
//  Timeline.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-02.
//

import SwiftUI

struct EditData {
    var editMode: Bool = false
    private(set) var toggleEditor: Bool = false
    private(set) var dayIndex: Int = 0
    
    mutating func toggleEditor(forDayIndex: Int = 0) {
        dayIndex = forDayIndex
        withAnimation {
            toggleEditor.toggle()
        }
        
    }
}

class TimelineData: ObservableObject {
    @Published var days: [Day]
    @Published var currentDayIndex: Int
    @Published var editData: EditData
    
    init(days: [Day] = generateEmptyWeek(), currentDayIndex: Int = 0) {
        self.days = days
        self.currentDayIndex = currentDayIndex
        self.editData = EditData()
    }
    
    var trajectHeight: CGFloat {
        var height: CGFloat = 50
        for index in (0..<currentDayIndex).reversed() {
            height += days[days.count - index - 1].height
        }
        return height
    }
    
    var totalHeight: CGFloat {
        var height: CGFloat = 0
        for day in days {
            height += day.height
        }
        return height
    }
    
    func toggleEditMode() {
        if editData.editMode == true {
            for i in 0..<days.count {
                days[i].toggleEditMode(state: false)
            }
        }
        editData.editMode.toggle()
    }
}

func generateEmptyWeek() -> [Day] {
    let today = Date()
    var days: [Day] = []
    for i in 0..<7 {
        let date = Calendar.current.date(byAdding: .day, value: 7 - i, to: today)!
        let weather = getWeather(for: date)
        let events: [Event] = []
        let day = Day(date: date, weather: weather, events: events)
        days.append(day)
    }
    return days
}

func generateDummyWeek() -> [Day] {
    let today = Date()
    var days: [Day] = []
    for i in 0..<7 {
        let date = Calendar.current.date(byAdding: .day, value: 7 - i, to: today)!
        let weather = getWeather(for: date)
        let events: [Event] = getEvents(amount: i)
        let day = Day(date: date, weather: weather, events: events)
        days.append(day)
    }
    return days
}
