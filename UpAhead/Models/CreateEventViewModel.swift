//
//  CreateEventViewModel.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-04-04.
//

import Foundation
import SwiftUI

extension CreateEventView {
    @MainActor class ViewModel: ObservableObject {
        @Published var selectedIcon: String = "house"
        @Published var title: String = ""
        @Published var keyboardHeight: CGFloat = 0
        @Published var color: Color = Color.blue
        @Published var time: Date = Date.now
        
        let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink, .gray, .black, .white]
        
        let symbols = [
            "house",
            "person",
            "car",
            "star",
            "flag",
            "music.note",
            "film",
            "book",
            "doc",
            "folder",
            "paperplane",
            "pencil",
            "trash",
            "heart",
            "moon.stars",
            "sun.max",
            "globe",
            "gear",
            "wrench",
            "clock",
            "bolt",
            "battery.100",
            "waveform",
            "antenna.radiowaves.left.and.right"
        ]
        
        func getEvent(date: Date) -> Event {
            var dayDate = date
            let calendar = Calendar.current
            let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
            if let hour = timeComponents.hour, let minute = timeComponents.minute {
                let dayComponents = calendar.dateComponents([.year, .month, .day], from: dayDate)
                var newDayComponents = DateComponents()
                newDayComponents.year = dayComponents.year
                newDayComponents.month = dayComponents.month
                newDayComponents.day = dayComponents.day
                newDayComponents.hour = hour
                newDayComponents.minute = minute
                newDayComponents.second = 0
                dayDate = calendar.date(from: newDayComponents)!
            }
            return Event(title: title, date: dayDate, iconName: selectedIcon, color: color, isCompleted: false)
        }
    }
}
