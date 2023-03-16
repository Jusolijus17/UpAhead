//
//  DayStruct.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-06.
//

import Foundation
import SwiftUI

struct Day {
    let date: Date
    let weather: WeatherData?
    var events: [Event]
    var editMode: Bool = false
    var height: CGFloat {
        var height: CGFloat = events.count <= 1 ? 200 : CGFloat((events.count * 100) + 100)
        if editMode && events.count > 0 {
            height += 100
        }
        return height
    }
    
    mutating func addEvent(_ event: Event) {
        events.append(event)
    }
}

struct Event {
    let title: String
    let iconName: String
    let color: Color
    let isCompleted: Bool
}

func getEvents(amount: Int, random: Bool) -> [Event] {
    let event1 = Event(title: "Meeting with Client A", iconName: "briefcase.fill", color: .blue, isCompleted: false)
    let event2 = Event(title: "Lunch with Colleagues", iconName: "cart.fill", color: .green, isCompleted: true)
    let event3 = Event(title: "Fitness Class", iconName: "figure.walk.circle.fill", color: .orange, isCompleted: false)
    
    var events = [event1, event2, event3]
    
    if random {
        events.shuffle()
    }
    
    if amount < events.count {
        events = Array(events.prefix(amount))
    }
    
    return events
}

func getWeather(for date: Date) -> WeatherData {
    // Return a dummy WeatherData object with dummy weather data
    let dummyWeatherConditions = ["clear sky", "few clouds", "scattered clouds", "broken clouds", "shower rain", "rain", "thunderstorm", "snow", "mist"]
    let randomCondition = dummyWeatherConditions.randomElement()!
    let dummyWeather = Weather(id: 800, main: "Clear", description: randomCondition)
    let dummyMain = Main(temp: Double.random(in: 15.0...30.0))
    return WeatherData(weather: [dummyWeather], main: dummyMain)
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
