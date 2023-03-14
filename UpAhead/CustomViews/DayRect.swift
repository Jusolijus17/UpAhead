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
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack {
                    if titleSide == .right {
                        VStack {
                            if let weather = day.weather {
                                WeatherView(weather: weather, side: titleSide)
                            } else {
                                Text("")
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
    //                        if day.events.count == 0 {
    //                            AddBox()
    //                                .onTapGesture {
    //                                    editData.dayIndex = index
    //                                    withAnimation {
    //                                        editData.editMode = true
    //                                    }
    //                                }
    //                        } else {
    //                            EventBox(event: day.events[0])
    //                        }
    //                        Spacer()
                        }
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .top)
                        
                        Spacer().frame(width: 40)
                        
                        VStack {
                            TitleView(date: day.date, side: titleSide)
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        VStack {
                            TitleView(date: day.date, side: titleSide)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Spacer().frame(width: 40)
                        
                        VStack {
                            if let weather = day.weather {
                                WeatherView(weather: weather, side: titleSide)
                            } else {
                                Text("")
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
    //                        if day.events.count == 0 {
    //                            AddBox()
    //                                .onTapGesture {
    //                                    editData.dayIndex = index
    //                                    withAnimation {
    //                                        editData.editMode = true
    //                                    }
    //                                }
    //                        } else {
    //                            EventBox(event: day.events[0])
    //                        }
                        }
                        .padding(.bottom)
                        .frame(maxWidth: .infinity)
                    }
                }
                EventSection(events: day.events, initialSide: titleSide)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
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
                        .frame(maxWidth: .infinity, alignment: .trailing)
                } else {
                    Image(systemName: symbolName)
                        .symbolRenderingMode(.multicolor)
                }
            }
            Text("\(String(format: "%.1f", weather.main.temp)) °C")
                .frame(maxWidth: side == .left ? .infinity : nil, alignment: side == .right ? .trailing : .leading)
                .font(.system(size: 20, design: .rounded))
                .foregroundColor(.white)
        }
        .padding(side == .right ? .trailing : .leading, 10)
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
        .padding(.top, -5)
        .onAppear {
            formatter.dateFormat = "MMM d"
        }
    }
}

struct EventSection: View {
    @State var events: [Event]
    let initialSide: Side
    var body: some View {
        HStack {
            // Left side here
            VStack(spacing: 0) {
                ForEach(0..<events.count, id: \.self) { i in
                    if initialSide == .left && i.isMultiple(of: 2) {
                        EventBox(event: events[i], side: .left)
                        if i != events.count - 1 {
                            Spacer()
                        }
                    } else if initialSide == .right && !i.isMultiple(of: 2) {
                        Spacer()
                        EventBox(event: events[i], side: .left)
                    }
                }
                if initialSide == .right && !events.count.isMultiple(of: 2) {
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            
            Spacer().frame(width: 40)
            
            // Right side here
            VStack(spacing: 0) {
                ForEach(0..<events.count, id: \.self) { i in
                    if initialSide == .right && i.isMultiple(of: 2) {
                        EventBox(event: events[i], side: .right)
                        if i != events.count - 1 {
                            Spacer()
                        }
                    } else if initialSide == .left && !i.isMultiple(of: 2) {
                        Spacer()
                        EventBox(event: events[i], side: .right)
                    }
                }
                if initialSide == .left && !events.count.isMultiple(of: 2) {
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
}

struct EditData {
    var editMode: Bool
    var dayIndex: Int
}

func generateDay() -> Day {
    let date = Date()
    let weather = WeatherData(weather: [Weather(id: 800, main: "Clear", description: "clear sky")], main: Main(temp: 20.0))
    
    let meetingEvent = Event(title: "Meeting", iconName: "calendar", color: .blue, isCompleted: false)
    let lunchEvent = Event(title: "Lunch with Bob", iconName: "food", color: .green, isCompleted: false)
    let events = [meetingEvent, meetingEvent, meetingEvent, meetingEvent, lunchEvent]
    
    let day = Day(date: date, weather: weather, events: events)
    return day
}


struct DayRect_Previews: PreviewProvider {
    static var previews: some View {
        let day = generateDay()
        DayRect(day: .constant(day), index: 0, titleSide: .left, editData: .constant(EditData(editMode: false, dayIndex: 0)))
            .background(Color(hex: "394A59"))
            .frame(height: day.height)
    }
}
