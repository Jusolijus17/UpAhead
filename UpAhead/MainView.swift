//
//  ContentView.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-02.
//

import SwiftUI
import Combine

struct MainView: View {
    @StateObject var timelineData: TimelineData
    @State private var dragOffset: CGFloat = 0
    @State var toggleEditor: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color(hex: "394A59")
                    .ignoresSafeArea()
                VStack {
                    ScrollViewReader { proxy in
                        ScrollView {
                            ZStack {
                                GeometryReader { geo in
                                    VStack(spacing: 0) {
                                        ForEach(0..<timelineData.days.count, id: \.self) { i in
                                            DayRect(day: $timelineData.days[i], index: i, titleSide: i.isMultiple(of: 2) ? .left : .right, editData: $timelineData.editData)
                                                .id("day\(timelineData.days.count - i)")
                                                .frame(height: timelineData.days[i].height)
                                        }
                                        Spacer().frame(height: 0)
                                            .id("bottom")
                                    }
                                }
                                
                                TrajectView()
                            }
                        }
                        .onChange(of: timelineData.currentDayIndex) { newValue in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation {
                                    if newValue != 0 {
                                        proxy.scrollTo("mark\(timelineData.days.count - newValue)", anchor: .bottom)
                                    } else {
                                        proxy.scrollTo("bottom", anchor: .bottom)
                                    }
                                }
                            }
                        }
                    }

                    BottomButtons()
                }

                VStack {
                    if toggleEditor {
                        VStack {
                            Spacer()
                            CreateEventView(day: $timelineData.days[timelineData.editData.dayIndex])
                                .offset(y: max(dragOffset, 0))
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            dragOffset = value.translation.height
                                        }
                                        .onEnded { value in
                                            let threshold = UIScreen.main.bounds.height * 0.2
                                            if value.translation.height > threshold {
                                                withAnimation {
                                                    timelineData.editData.toggleEditor()
                                                    dragOffset = 0
                                                }
                                            } else {
                                                withAnimation {
                                                    dragOffset = 0
                                                }
                                            }
                                        }
                                )
                        }
                        .transition(.move(edge: .bottom))
                        .padding(.horizontal, 5)
                        .padding(.bottom, 5)
                        .ignoresSafeArea()
                    }
                }

            }
            .onAppear {
                toggleEditor = timelineData.editData.toggleEditor
            }
            .onChange(of: timelineData.editData.toggleEditor) { newValue in
                withAnimation {
                    toggleEditor = newValue
                }
            }

        }
        .environmentObject(timelineData)
        .navigationBarBackButtonHidden(true)
    }
    
}

struct BottomButtons: View {
    @EnvironmentObject var timelineData: TimelineData
    var body: some View {
        HStack {
            Button(action: {
                if timelineData.currentDayIndex > 0 {
                    withAnimation {
                        timelineData.currentDayIndex -= 1
                    }
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.error)
                }
            }) {
                Text("Skip Stop")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            
            Button {
                withAnimation {
                    timelineData.toggleEditMode()
                }
            } label: {
                Text("Edit")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: 75)
                    .background(Color.gray)
                    .cornerRadius(10)
            }
            
            
            Button(action: {
                if timelineData.currentDayIndex < timelineData.days.count {
                    withAnimation {
                        timelineData.currentDayIndex += 1
                    }
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                }
            }) {
                Text("Next Stop")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal, 15)
    }
}

func generateWeek() -> [Day] {
    let today = Date()
    var days: [Day] = []
    for i in 0..<7 {
        let date = Calendar.current.date(byAdding: .day, value: 7 - i, to: today)!
        let weather = getWeather(for: date)
        let events: [Event] = getEvents(amount: i)
        let day = Day(date: date, weather: weather, events: events)
        days.append(day)
    }
    return days
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(timelineData: TimelineData(days: generateWeek(), currentDayIndex: 3))
    }
}
