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
            HStack {
                if titleSide == .right {
                    VStack {
                        if let weather = day.weather {
                            WeatherView(weather: weather, side: titleSide)
                        } else {
                            Text("")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        Spacer()
//                        EventBox(icon: "square.and.pencil", title: "Devoir INF3405", isChecked: true)
                        if day.events.count == 0 {
                            AddBox()
                                .onTapGesture {
                                    editData.dayIndex = index
                                    withAnimation {
                                        editData.editMode = true
                                    }
                                }
                        } else {
                            EventBox(event: day.events[0])
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    Spacer().frame(width: 40)
                    
                        VStack {
                            HStack(spacing: 0) {
                                TitleView(date: day.date, side: titleSide)
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack {
                        TitleView(date: day.date, side: titleSide)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    Spacer().frame(width: 40)
                    
                    VStack {
                        if let weather = day.weather {
                            WeatherView(weather: weather, side: titleSide)
                        } else {
                            Text("")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        Spacer()
                        if day.events.count == 0 {
                            AddBox()
                                .onTapGesture {
                                    editData.dayIndex = index
                                    withAnimation {
                                        editData.editMode = true
                                    }
                                }
                        } else {
                            EventBox(event: day.events[0])
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
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

struct EditData {
    var editMode: Bool
    var dayIndex: Int
}

func generateDay() -> Day {
    let date = Date()
    let weather = WeatherData(weather: [Weather(id: 800, main: "Clear", description: "clear sky")], main: Main(temp: 20.0))
    
    let meetingEvent = Event(title: "Meeting", iconName: "calendar", color: .blue, isCompleted: false)
    let lunchEvent = Event(title: "Lunch with Bob", iconName: "food", color: .green, isCompleted: false)
    let events = [meetingEvent, lunchEvent]
    
    let day = Day(date: date, weather: weather, events: events)
    return day
}


struct DayRect_Previews: PreviewProvider {
    static var previews: some View {
        DayRect(day: .constant(generateDay()), index: 0, titleSide: .right, editData: .constant(EditData(editMode: false, dayIndex: 0)))
            .background(Color(hex: "394A59"))
            .frame(height: 200)
    }
}
