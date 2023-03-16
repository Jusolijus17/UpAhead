//
//  Timeline.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-02.
//

import SwiftUI

struct EditData {
    var editMode: Bool
    var dayIndex: Int
}

class TimelineData: ObservableObject {
    @Published var days: [Day]
    @Published var currentDayIndex: Int
    @Published var editData: EditData
    
    init(days: [Day], currentDayIndex: Int) {
        self.days = days
        self.currentDayIndex = currentDayIndex
        self.editData = EditData(editMode: false, dayIndex: 0)
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
    
    func toggleEditMode() {
        for i in 0..<days.count {
            days[i].editMode.toggle()
        }
        editData.editMode.toggle()
    }
}
