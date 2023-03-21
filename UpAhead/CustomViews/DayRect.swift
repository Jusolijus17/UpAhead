//
//  DayRect.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-03.
//

import SwiftUI

struct DayRect: View {
    @Binding var day: Day
    let index: Int
    let titleSide: Side
    @Binding var editData: EditData
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                if titleSide == .left {
                    titleView
                        .id("title\(index)")
                    Spacer().frame(width: 40)
                    HStack(spacing: 10) {
                        weatherView
                        editData.editMode ? EditButton(day: $day) : nil
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    HStack(spacing: 10) {
                        editData.editMode ? EditButton(day: $day) : nil
                        weatherView
                    }
                    .frame(maxWidth: .infinity)
                    Spacer().frame(width: 40)
                    titleView
                        .id("title\(index)")
                }
            }
            EventSection(events: $day.events, initialSide: titleSide, triggerAddEvent: { editData.toggleEditor(forDayIndex: index) })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private var titleView: some View {
        TitleView(date: day.date, side: titleSide)
    }
    
    private var weatherView: some View {
        if let weather = day.weather {
            return AnyView(WeatherView(weather: weather, side: titleSide))
        } else {
            return AnyView(Text("").frame(maxWidth: .infinity, alignment: .trailing))
        }
    }
}

struct EditButton: View {
    @Binding var day: Day
    var body: some View {
        Button {
            withAnimation {
                day.toggleEditMode()
            }
        } label: {
            Text("Edit")
                .font(.system(size: 20))
                .padding(5)
                .foregroundColor(.black)
                .background(.gray)
                .cornerRadius(10)
        }
    }
}


struct WeatherView: View {
    let weather: WeatherData
    let side: Side
    
    var body: some View {
        HStack {
            if let symbolName = weatherSymbolMapping[weather.weather[0].description] {
                if side == .right {
                    Image(systemName: symbolName)
                        .symbolRenderingMode(.multicolor)
//                        .frame(maxWidth: .infinity, alignment: .trailing)
                } else {
                    Image(systemName: symbolName)
                        .symbolRenderingMode(.multicolor)
                }
            }
            Text("\(String(format: "%.1f", weather.main.temp)) °C")
//                .frame(maxWidth: side == .left ? .infinity : nil, alignment: side == .right ? .trailing : .leading)
                .font(.system(size: 20, design: .rounded))
                .foregroundColor(.white)
        }
        //.padding(side == .right ? .trailing : .leading, 10)
    }
}

struct TitleView: View {
    let date: Date
    let side: Side
    let formatter = DateFormatter()
    
    var body: some View {
        VStack(alignment: side == .left ? .trailing : .leading) {
            Text(date.weekday)
                .font(.system(size: 25, weight: .semibold, design: .rounded))
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, alignment: side == .left ? .trailing : .leading)
            
            Text(date, style: .date)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(side == .left ? .trailing : .leading, 20)
        .onAppear {
            formatter.dateFormat = "MMM d"
        }
    }
}

struct EventSection: View {
    @Binding var events: [Event]
    let initialSide: Side
    var triggerAddEvent: () -> Void

    var body: some View {
        HStack(spacing: 25) {
            if initialSide == .left {
                VStack1(events: $events, side: .left, onAddTap: { triggerAddEvent() })
                VStack2(events: $events, side: .right, onAddTap: { triggerAddEvent() })
            } else {
                VStack2(events: $events, side: .left, onAddTap: { triggerAddEvent() })
                VStack1(events: $events, side: .right, onAddTap: { triggerAddEvent() })
            }
        }
    }

    struct VStack1: View {
        @Binding var events: [Event]
        let side: Side
        var onAddTap: () -> Void

        var body: some View {
            VStack(spacing: 100) {
                ForEach(events.indices.filter { $0 % 2 == 0 }, id: \.self) { index in
                    if events[index].title != "AddBox" {
                        EventBox(event: $events[index], side: side)
                    } else {
                        AddBox {
                            onAddTap()
                        }
                    }
                }
                if events.count.isMultiple(of: 2) {
                    Spacer().frame(height: 0)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    struct VStack2: View {
        @Binding var events: [Event]
        let side: Side
        var onAddTap: () -> Void

        var body: some View {
            VStack(spacing: 100) {
                if events.count.isMultiple(of: 2) {
                    Spacer().frame(height: 0)
                }
                ForEach(events.indices.filter { $0 % 2 == 1 }, id: \.self) { index in
                    if events[index].title != "AddBox" {
                        EventBox(event: $events[index], side: side)
                    } else {
                        AddBox {
                            onAddTap()
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

func generateDay() -> Day {
    let date = Date()
    let weather = WeatherData(weather: [Weather(id: 800, main: "Clear", description: "clear sky")], main: Main(temp: 20.0))
    
    let meetingEvent = Event(title: "Meeting", iconName: "calendar", color: .blue, isCompleted: false)
    let lunchEvent = Event(title: "Lunch with Bob", iconName: "food", color: .green, isCompleted: false)
    let events = [meetingEvent, lunchEvent, lunchEvent]
    
    var day = Day(date: date, weather: weather, events: events)
    day.toggleEditMode()
    return day
}


struct DayRect_Previews: PreviewProvider {
    static var previews: some View {
        let day = generateDay()
        DayRect(day: .constant(day), index: 0, titleSide: .right, editData: .constant(EditData(editMode: true, dayIndex: 0)))
            .background(Color(hex: "394A59"))
            .frame(height: day.height)
    }
}
