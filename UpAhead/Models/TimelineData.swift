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
    @Published var currentDayIndex: Int
    @Published var editData: EditData
    @ObservedObject var weatherModel = WeatherModel()
    
    init(days: [Day] = [], currentDayIndex: Int = 0) {
        self.currentDayIndex = currentDayIndex
        self.editData = EditData()
        self.days = days
        
        if self.days.count == 0 {
            self.days = generateEmptyWeek()
        }
        self.weatherModel.fetchWeatherForecast()
    }
    
    var currentDay: Day {
        return days[currentDayIndex]
    }
    
    var trajectHeight: CGFloat {
        var height: CGFloat = 50
        for index in (0..<currentDayIndex).reversed() {
            height += days[days.count - index - 1].height
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
    
    func toggleEditMode() {
        if editData.editMode == true {
            for i in 0..<days.count {
                days[i].toggleEditMode(state: false)
            }
        }
        editData.editMode.toggle()
    }
    
    func updateCurrentDay() {
        if currentDayIndex < days.count - 1 {
            currentDayIndex += 1
        }
    }
    
    func nextEvent() {
        days[currentDayIndex].nextEvent()
    }
    
    func previousEvent() {
        days[currentDayIndex].previousEvent()
    }
    
    private func generateEmptyWeek() -> [Day] {
        let calendar = Calendar.current
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
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    let daysToAdd = 2 - calendar.component(.weekday, from: today)
    let monday = calendar.date(byAdding: .day, value: daysToAdd, to: today)!
    var days: [Day] = []
    for i in 1...7 {
        let date = calendar.date(byAdding: .day, value: 7 - i, to: monday)!
        let events: [Event] = getEvents(amount: i)
        let day = Day(date: date, events: events)
        days.append(day)
    }
    return days
}


