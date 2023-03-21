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
    
    init(days: [Day], currentDayIndex: Int) {
        self.days = days
        self.currentDayIndex = currentDayIndex
        self.editData = EditData()
    }
    
    var trajectHeight: CGFloat {
        var height: CGFloat = 0
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
