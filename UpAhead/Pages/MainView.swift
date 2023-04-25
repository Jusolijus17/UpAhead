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
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.accentColor
                    .ignoresSafeArea()
                
                VStack {
                    ZStack(alignment: .top) {
                        Timeline()
                        ProgressHeader()
                    }
                    BottomButtons()
                }

                Editor()
            }
        }
        .environmentObject(timelineData)
        .navigationBarBackButtonHidden(true)
    }
    
}

struct TopBar: View {
    var body: some View {
        ZStack {
            Text("UpAhead!")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal)
                .background(Color.accentColor)
                .cornerRadius(20)
                .shadow(radius: 10)
        }
        .frame(maxWidth: .infinity)
    }
}

struct Timeline: View {
    @EnvironmentObject var timelineData: TimelineData
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ZStack {
                    GeometryReader { geo in
                        VStack(spacing: 0) {
                            ForEach(0..<timelineData.days.count, id: \.self) { i in
                                let titleSide: Side = i.isMultiple(of: 2) ? .left : .right
                                let model = DayView.ViewModel(index: i, titleSide: titleSide, weatherModel: timelineData.weatherModel)
                                DayView(model: model, day: $timelineData.days[i], editData: $timelineData.editData)
                                    .id("day\(timelineData.days.count - i)")
                                    .frame(height: timelineData.days[i].height)
                            }
                            Spacer().frame(height: 0)
                                .id("bottom")
                        }
                    }
                    
                    TrajectView()
                }
                .padding(.top, 50)
            }
            .onAppear {
                if timelineData.currentDayIndex != 0 {
                    proxy.scrollTo("mark\(timelineData.days.count - timelineData.currentDayIndex)", anchor: .bottom)
                } else {
                    proxy.scrollTo("bottom", anchor: .bottom)
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
    }
}

struct BottomButtons: View {
    @EnvironmentObject var timelineData: TimelineData
    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    timelineData.previousEvent()
                }
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
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
                withAnimation {
                    timelineData.nextEvent()
                }
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
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

struct Editor: View {
    @EnvironmentObject var timelineData: TimelineData
    
    @State private var dragOffset: CGFloat = 0
    @State private var toggleEditor: Bool = false
    
    var body: some View {
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
        .onAppear {
            toggleEditor = timelineData.editData.toggleEditor
        }
        .onChange(of: timelineData.editData.toggleEditor) { newValue in
            withAnimation {
                toggleEditor = newValue
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(timelineData: TimelineData(days: generateDummyWeek(), currentDayIndex: 3))
    }
}
