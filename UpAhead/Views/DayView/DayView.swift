//
//  DayRect.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-03.
//

import SwiftUI
import SpriteKit

struct DayView: View {
    @StateObject var model: ViewModel
    @Binding var day: Day
    @Binding var editData: EditData
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    if model.titleSide == .left {
                        TitleView(date: day.date, side: model.titleSide)
                            .id("title\(model.index)")
                        Spacer().frame(width: 40)
                        HStack(spacing: 10) {
                            editData.editMode ? AnyView(EditButton(day: $day).padding(.top, 10)) : AnyView(WeatherView())
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        HStack(spacing: 10) {
                            editData.editMode ? AnyView(EditButton(day: $day).padding(.top, 10)) : AnyView(WeatherView())
                        }
                        .frame(maxWidth: .infinity)
                        Spacer().frame(width: 40)
                        TitleView(date: day.date, side: model.titleSide)
                            .id("title\(model.index)")
                    }
                }
                .padding(.bottom, 5)
                .background(.orange.opacity(0.8))
                
                EventSection(day: $day) {
                    editData.toggleEditor(forDayIndex: model.index)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .environmentObject(model)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(40)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .shadow(radius: 10)
    }
}

struct EditButton: View {
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
    
    var day = Day(date: date, events: events)
    day.toggleEditMode()
    return day
}


struct DayRect_Previews: PreviewProvider {
    static var previews: some View {
        let weatherModel = WeatherModel()
        let model = DayView.ViewModel(index: 3, titleSide: .left, weatherModel: weatherModel)
        let day = generateDay()
        let editData = EditData()
        ZStack {
            Color.accentColor
                .ignoresSafeArea()
            DayView(model: model, day: .constant(day), editData: .constant(editData))
                .frame(height: day.height)
        }
    }
}
