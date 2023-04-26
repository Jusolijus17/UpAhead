//
//  DayRect.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-03.
//

import SwiftUI
import ConfettiSwiftUI

struct DayView: View {
    @EnvironmentObject var timelineData: TimelineData
    @StateObject var model: ViewModel
    @Binding var day: Day
    @Binding var editData: EditData
    @State var confettiCounter: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                if model.titleSide == .left {
                    TitleView(date: day.date, side: model.titleSide)
                        .id("title\(model.index)")
                    Spacer().frame(width: 40)
                    HStack(spacing: 10) {
                        editData.editMode ? AnyView(CustomEditButton(day: $day)) : AnyView(WeatherView())
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    HStack(spacing: 10) {
                        editData.editMode ? AnyView(CustomEditButton(day: $day)) : AnyView(WeatherView())
                    }
                    .frame(maxWidth: .infinity)
                    Spacer().frame(width: 40)
                    TitleView(date: day.date, side: model.titleSide)
                        .id("title\(model.index)")
                }
            }
            .padding(.bottom, 5)
            .background(day.weekDay.isWeekend ? model.weekendColor : model.weekColor)
            
            EventSection(day: $day) {
                editData.toggleEditor(forDayIndex: model.index)
            }
        }
        .environmentObject(model)
        .environmentObject(timelineData)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(40)
        .padding(.horizontal, Constants.dayViewHorizontalPadding)
        .padding(.vertical, 5)
        .shadow(radius: 10)
        .confettiCannon(counter: $confettiCounter, num: 50, radius: 400.0)
        .onChange(of: timelineData.currentDay.isDayCompleted) { newValue in
            if newValue && timelineData.currentDayIndex == model.index {
                confettiCounter += 1
            }
        }
    }
}

struct CustomEditButton: View {
    @Binding var day: Day
    
    var body: some View {
        Button {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            withAnimation {
                day.toggleEditMode()
            }
        } label: {
            HStack(spacing: 5) {
                Text("Edit day")
                    .fontWeight(.semibold)
                Image(systemName: "slider.horizontal.below.square.and.square.filled")
            }
            .padding(10)
            .background(.red)
            .cornerRadius(10)
            .foregroundColor(.white)
        }
    }
}


struct WeatherView: View {
    @EnvironmentObject var model: DayView.ViewModel
    
    var body: some View {
        HStack {
            Image(systemName: model.symbolName)
                .symbolRenderingMode(.multicolor)
            
            Text("\(model.temperature)")
                .font(.system(size: 20, design: .rounded))
                .foregroundColor(.white)
        }
        .onReceive(model.weatherModel.$dailyForecasts) { forecasts in
            model.updateWeather(forecasts: forecasts)
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

func generateDay() -> Day {
    let date = Date()
    
    let meetingEvent = Event(title: "Meeting", iconName: "calendar", color: .blue, isCompleted: false)
    let lunchEvent = Event(title: "Lunch with Bob", iconName: "food", color: .green, isCompleted: false)
    let events = [meetingEvent, lunchEvent, lunchEvent]
    
    let day = Day(date: date, events: events)
    //day.toggleEditMode()
    return day
}


struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        let weatherModel = WeatherModel()
        let model = DayView.ViewModel(index: 3, titleSide: .left, weatherModel: weatherModel)
        let day = generateDay()
        let editData = EditData()
        let timelineData = TimelineData()
        ZStack {
            Color.accentColor
                .ignoresSafeArea()
            DayView(model: model, day: .constant(day), editData: .constant(editData))
                .frame(height: day.height)
                .environmentObject(timelineData)
        }
    }
}
