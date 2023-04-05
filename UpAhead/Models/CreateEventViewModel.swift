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
        
        func getEmptyEvent() -> Event {
            let event = Event(title: title, iconName: selectedIcon, color: color, isCompleted: false)
            return event
        }
        
        func getEvent() -> Event {
            let newEvent = Event(title: title, iconName: selectedIcon, color: color, isCompleted: false)
            return newEvent
        }
    }
}
