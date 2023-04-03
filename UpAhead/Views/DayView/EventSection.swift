//
//  EventSection.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-31.
//

import SwiftUI
import SpriteKit

struct EventSection: View {
    @EnvironmentObject var model: DayView.ViewModel
    @Binding var day: Day
    var triggerAddEvent: () -> Void

    var body: some View {
        HStack(spacing: 25) {
            if model.titleSide == .left {
                VStack1(side: .left)
                VStack2(side: .right)
            } else {
                VStack2(side: .left)
                VStack1(side: .right)
            }
        }
    }
    
    private func VStack1(side: Side) -> some View {
        return VStack(spacing: 100) {
            ForEach(day.events.indices.filter { $0 % 2 == 0 }, id: \.self) { index in
                if day.events[index].title != "AddBox" {
                    EventBox(event: $day.events[index], isEditing: $day.editMode, side: side) {
                        day.deleteEvent(index: index)
                    }
                } else {
                    AddBox {
                        triggerAddEvent()
                    }
                }
            }
            if day.events.count.isMultiple(of: 2) {
                Spacer().frame(height: 0)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func VStack2(side: Side) -> some View {
        VStack(spacing: 100) {
            if day.events.count.isMultiple(of: 2) {
                Spacer().frame(height: 0)
            }
            ForEach(day.events.indices.filter { $0 % 2 == 1 }, id: \.self) { index in
                if day.events[index].title != "AddBox" {
                    EventBox(event: $day.events[index], isEditing: $day.editMode, side: side) {
                        day.deleteEvent(index: index)
                    }
                } else {
                    AddBox {
                        triggerAddEvent()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct EventSection_Preview: PreviewProvider {
    static var previews: some View {
        DayRect_Previews.previews
    }
}
