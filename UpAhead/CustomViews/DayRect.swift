//
//  DayRect.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-03.
//

import SwiftUI
import SpriteKit

struct DayRect: View {
    @Binding var day: Day
    let index: Int
    let titleSide: Side
    @Binding var editData: EditData
    @ObservedObject var weatherModel: WeatherModel
    
    @State var background: AnyView = AnyView(Color.accentColor)
    
    var body: some View {
        
        ZStack {
            weatherEffect
            
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
                EventSection(events: $day.events, weatherForecasts: weatherModel, index: index, initialSide: titleSide, triggerAddEvent: { editData.toggleEditor(forDayIndex: index) })
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .overlay(weatherLandingBottomEffect)
        }
        .background(background)
        .cornerRadius(30)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .shadow(radius: 10)
        .onReceive(weatherModel.$dailyForecasts) { forecasts in
            if let forecasts = forecasts {
                background = getBackground(forecast: forecasts[index])
            }
        }
    }
    
    private var weatherEffect: some View {
        var view: AnyView = AnyView(EmptyView())
//        if let weatherType = getWeatherType() {
//            if weatherType == .rain {
//                view = AnyView(
//                    SpriteView(scene: RainFall(), options: [.allowsTransparency])
//                        .allowsHitTesting(false)
//                )
//            }
//        }
        return view
    }
    
    private var weatherLandingEffect: some View {
        var view: AnyView = AnyView(EmptyView())
//        if let weatherType = getWeatherType() {
//            if weatherType == .rain {
//                view = AnyView(
//                    SpriteView(scene: RainFallLanding(), options: [.allowsTransparency])
//                        .allowsHitTesting(false)
//                )
//            }
//        }
        return view
    }
    
    private var weatherLandingBottomEffect: some View {
        var view: AnyView = AnyView(EmptyView())
//        if let weatherType = getWeatherType() {
//            if weatherType == .rain {
//                view = AnyView(
//                    SpriteView(scene: RainFallLandingBottom(), options: [.allowsTransparency])
//                        .allowsHitTesting(false)
//                )
//            }
//        }
        return view
    }
    
    private var titleView: some View {
        TitleView(date: day.date, side: titleSide)
    }
    
    private var weatherView: some View {
        return AnyView(WeatherView(weatherForecasts: weatherModel, index: index, side: titleSide))
    }
    
    private func getBackground(forecast: DailyForecast) -> AnyView {
        if let weatherType = getWeatherType(forecast: forecast) {
            switch weatherType {
            case .sun:
                return AnyView(SunnyDayGradient())
            case .rain:
                return AnyView(RainyDayGradient())
            case .snow:
                return AnyView(EmptyView())
            case .cloud:
                return AnyView(CloudyDayGradient())
            }
        }
        return AnyView(EmptyView())
    }
    
    private func getWeatherType(forecast: DailyForecast) -> WeatherType? {
        if let weatherType = weatherTypeMapping[forecast.weather[0].description] {
            return weatherType
        }
        return nil
    }
}

struct RainyDayGradient: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.gray.opacity(0.6), Color(hex: "394A59")]),
            startPoint: .top,
            endPoint: .bottom
        )
        .background(.white)
    }
}

struct SunnyDayGradient: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.85), Color.blue.opacity(0.3)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .background(.white)
    }
}

struct CloudyDayGradient: View {
    var body: some View {
        ZStack {
            Image("cloud-background")
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            Rectangle()
                .foregroundColor(.secondary)
                .background(.ultraThinMaterial)
                .opacity(0.95)
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
    @ObservedObject var weatherForecasts: WeatherModel
    let index: Int
    let side: Side
    
    @State var symbolName: String = ""
    
    var body: some View {
        HStack {
            Image(systemName: symbolName)
                .symbolRenderingMode(.multicolor)
            
            Text("\(String(format: "%.1f", weatherForecasts.dailyForecasts?[index].temp.day ?? "-.-")) °C")
                .font(.system(size: 20, design: .rounded))
                .foregroundColor(.white)
        }
        .onReceive(weatherForecasts.$dailyForecasts) { forecasts in
            if let forecasts = forecasts {
                symbolName = weatherSymbolMapping[forecasts[index].weather[0].description] ?? ""
            }
        }
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
    @ObservedObject var weatherForecasts: WeatherModel
    let index: Int
    let initialSide: Side
    var triggerAddEvent: () -> Void

    var body: some View {
        HStack(spacing: 25) {
            if initialSide == .left {
                VStack1(side: .left)
                VStack2(side: .right)
            } else {
                VStack2(side: .left)
                VStack1(side: .right)
            }
        }
    }
    
    func VStack1(side: Side) -> some View {
        return VStack(spacing: 100) {
            ForEach(events.indices.filter { $0 % 2 == 0 }, id: \.self) { index in
                if events[index].title != "AddBox" {
                    EventBox(event: $events[index], side: side)
                        .overlay(weatherLandingEffect)
                } else {
                    AddBox {
                        triggerAddEvent()
                    }
                }
            }
            if events.count.isMultiple(of: 2) {
                Spacer().frame(height: 0)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    func VStack2(side: Side) -> some View {
        VStack(spacing: 100) {
            if events.count.isMultiple(of: 2) {
                Spacer().frame(height: 0)
            }
            ForEach(events.indices.filter { $0 % 2 == 1 }, id: \.self) { index in
                if events[index].title != "AddBox" {
                    EventBox(event: $events[index], side: side)
                        .overlay(weatherLandingEffect)
                } else {
                    AddBox {
                        triggerAddEvent()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var weatherLandingEffect: some View {
        var view: AnyView = AnyView(EmptyView())
//        if let weatherType = getWeatherType() {
//            if weatherType == .rain {
//                view = AnyView(
//                    SpriteView(scene: RainFallLanding(), options: [.allowsTransparency])
//                        .allowsHitTesting(false)
//                )
//            }
//        }
        return view
    }
    
    private func getWeatherType(forecast: DailyForecast) -> WeatherType? {
        if let weatherType = weatherTypeMapping[forecast.weather[0].description] {
            return weatherType
        }
        return nil
    }
    
}

func generateDay() -> Day {
    let date = Date()
    
    let meetingEvent = Event(title: "Meeting", iconName: "calendar", color: .blue, isCompleted: false)
    let lunchEvent = Event(title: "Lunch with Bob", iconName: "food", color: .green, isCompleted: false)
    let events = [meetingEvent, lunchEvent, lunchEvent]
    
    var day = Day(date: date, events: events)
    day.toggleEditMode()
    return day
}


struct DayRect_Previews: PreviewProvider {
    static var previews: some View {
        let day = generateDay()
        DayRect(day: .constant(day), index: 0, titleSide: .right, editData: .constant(EditData(editMode: true, dayIndex: 0)), weatherModel: WeatherModel())
            //.background(Color(hex: "394A59"))
            .frame(height: day.height)
    }
}
