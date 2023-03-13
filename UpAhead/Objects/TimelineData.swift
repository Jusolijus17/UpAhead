//
//  Timeline.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-02.
//

import SwiftUI

class TimelineData: ObservableObject {
    @Published var days: [Day]
    @Published var currentDayIndex: Int
    
    init(days: [Day], currentDayIndex: Int) {
        self.days = days
        self.currentDayIndex = currentDayIndex
    }
    
    var trajectHeight: CGFloat {
        var height: CGFloat = 0
        for index in (0..<currentDayIndex).reversed() {
            height += days[days.count - index - 1].height
        }
        return height - 10
    }
    
    var totalHeight: CGFloat {
        var height: CGFloat = 0
        for day in days {
            height += day.height
        }
        return height
    }
}
