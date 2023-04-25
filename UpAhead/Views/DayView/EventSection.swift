//
//  EventSection.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-31.
//

import SwiftUI

struct EventSection: View {
    @EnvironmentObject var model: DayView.ViewModel
    @EnvironmentObject var timelineData: TimelineData
    @Binding var day: Day
    var triggerAddEvent: () -> Void
    
    @State var isMoving: Bool = false

    var body: some View {
        let emptyInset = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        ZStack {
            //indicators
            
            List {
                ForEach($day.events) { $event in
                    let alignment = model.getAlignment(index: event.index)
                    EventRow(alignment: alignment, event: $event, editMode: $day.editMode)
                }
                .onMove(perform: move)
                .listRowSeparator(.hidden)
                .listRowInsets(emptyInset)
                .listRowBackground(EmptyView())
            }
            .padding(.vertical)
            .padding(.horizontal, Constants.listHorizontalPadding)
            .listStyle(.plain)
            .scrollDisabled(true)
        }
        .onChange(of: day.events) { newEvents in
            if !isMoving {
                print("Reorganizing!")
                withAnimation {
                    day.reorganizeEvents()
                }
            }
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        withAnimation {
            day.events.move(fromOffsets: source, toOffset: destination)
        }
        isMoving = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isMoving = false
        }
    }
    
    var indicators: AnyView {
        if timelineData.currentDayIndex == model.index {
            print("Pourcent: \(day.completionPercent)")
            return AnyView(HStack(spacing: 0) {
                PrecisionIndicator(currentPourcentage: day.completionPercent, magnification: 0.4)
                PrecisionIndicator(currentPourcentage: day.completionPercent, magnification: 0.4, alignement: .trailing)
            }
            .foregroundColor(.blue))
        }
        return AnyView(EmptyView())
    }
    
    //    private func VStack1(side: Side) -> some View {
//        return VStack(spacing: 100) {
//            ForEach(day.events.indices.filter { $0 % 2 == 0 }, id: \.self) { index in
//                if day.events[index].title != "AddBox" {
//                    EventBox(event: $day.events[index], isEditing: $day.editMode, side: side) {
//                        day.deleteEvent(index: index)
//                    }
//                } else {
//                    AddBox {
//                        triggerAddEvent()
//                    }
//                }
//            }
//            if day.events.count.isMultiple(of: 2) {
//                Spacer().frame(height: 0)
//            }
//        }
//        .frame(maxWidth: .infinity)
//    }
//
//    private func VStack2(side: Side) -> some View {
//        VStack(spacing: 100) {
//            if day.events.count.isMultiple(of: 2) {
//                Spacer().frame(height: 0)
//            }
//            ForEach(day.events.indices.filter { $0 % 2 == 1 }, id: \.self) { index in
//                if day.events[index].title != "AddBox" {
//                    EventBox(event: $day.events[index], isEditing: $day.editMode, side: side) {
//                        day.deleteEvent(index: index)
//                    }
//                } else {
//                    AddBox {
//                        triggerAddEvent()
//                    }
//                }
//            }
//        }
//        .frame(maxWidth: .infinity)
//    }
}

struct EventRow: View {
    var alignment: Alignment
    @Binding var event: Event
    @Binding var editMode: Bool
    
    var body: some View {
        HStack {
            EventBox(event: $event, isEditing: $editMode)
                .frame(maxWidth: .infinity, alignment: alignment)
        }
        .id(event.id)
        .onDrag {
            NSItemProvider()
        } preview: {
            EventBox(event: $event, isEditing: .constant(false))
                .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }
}

struct EventSection_Preview: PreviewProvider {
    static var previews: some View {
        DayView_Previews.previews
    }
}
