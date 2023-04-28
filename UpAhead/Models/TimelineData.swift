//
//  Timeline.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-02.
//

import SwiftUI
import Combine

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
    @Published var currentDayIndex: Int = 0
    @Published var editData: EditData = EditData()
    @ObservedObject var weatherModel = WeatherModel()
    
    init(days: [Day] = []) {
        self.days = days
        self.currentDayIndex = getCurrentDayIndex()
        
        if self.days.count == 0 {
            self.days = generateEmptyWeek()
        }
        
        self.weatherModel.fetchWeatherForecast()
    }
    
    var currentDay: Day {
        return days[currentDayIndex]
    }
    
    var trajectHeight: CGFloat {
        var height: CGFloat = 0
        for index in (0..<currentDayIndex) {
            height += days[index].height
        }
        height += CGFloat((days[currentDayIndex].completedEventsCount + 1) * 100)
        return height
    }
    
    var totalHeight: CGFloat {
        var height: CGFloat = 0
        for day in days {
            height += day.height
        }
        return height
    }
    
    private var totalEventsCount: Int {
        var total: Int = 0
        for day in days {
            total += day.events.count
        }
        return total
    }
    
    private var totalCompletedEventsCount: Int {
        var total: Int = 0
        for day in days {
            total += day.completedEventsCount
        }
        return total
    }
    
    var completionPercent: Double {
        return (Double(totalCompletedEventsCount) / Double(totalEventsCount)) * 100
    }
    
    var isUpToDate: Bool {
        for i in 0..<currentDayIndex {
            if !days[i].isCompleted {
                return false
            }
        }
        return true
    }
    
    func getLateEventsList() -> [(String, Int)] {
        var lateList: [(String, Int)] = []
        if isUpToDate {
            return []
        }
        for i in 0..<currentDayIndex {
            let day = days[i]
            if !day.isCompleted {
                lateList.append((day.date.weekday, day.uncompletedEventsCount))
            }
        }
        return lateList
    }
    
    func getDayProgressionContribution(day: Day) -> Double {
        guard totalEventsCount != 0 else {
            return 0
        }
        return (Double(day.events.count) / Double(totalEventsCount)) * 100
    }
    
    func toggleEditMode() {
        if editData.editMode == true {
            for i in 0..<days.count {
                days[i].toggleEditMode(state: false)
            }
        }
        editData.editMode.toggle()
    }
    
    func nextEvent() {
        days[currentDayIndex].nextEvent()
    }
    
    func previousEvent() {
        days[currentDayIndex].previousEvent()
    }
    
    private func getCurrentDayIndex() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        for (index, day) in days.enumerated() {
            if calendar.isDate(day.date, inSameDayAs: today) {
                return index
            }
        }
        return 0
    }
    
    private func generateEmptyWeek() -> [Day] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        let today = calendar.startOfDay(for: Date())
        let monday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        var days: [Day] = []
        for i in 1...7 {
            let date = calendar.date(byAdding: .day, value: 7 - i, to: monday)!
            let events: [Event] = []
            let day = Day(date: date, events: events)
            days.append(day)
        }
        return days
    }

}

func generateDummyWeek() -> [Day] {
    var calendar = Calendar(identifier: .gregorian)
    calendar.firstWeekday = 2
    let today = calendar.startOfDay(for: Date())
    let daysToAdd = 2 - calendar.component(.weekday, from: today)
    let monday = calendar.date(byAdding: .day, value: daysToAdd, to: today)!
    var days: [Day] = []
    for i in 1...7 {
        let date = calendar.date(byAdding: .day, value: 7 - i, to: monday)!
        let events: [Event] = getEvents(amount: i)
        let day = Day(date: date, events: events)
        days.insert(day, at: 0)
    }
    return days
}


