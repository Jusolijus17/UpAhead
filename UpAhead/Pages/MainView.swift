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
                    .frame(maxHeight: .infinity)
                    BottomButtons()
                }
                
                Editor()
            }
        }
        .environmentObject(timelineData)
        .navigationBarBackButtonHidden(true)
    }
    
}

//struct Header: View {
//    var body: some View {
//        HStack {
//            Image(systemName: "arrow.triangle.2.circlepath")
//                .font(.system(size: 22))
//                .foregroundColor(.white)
//                .shadow(color: .black, radius: 5)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.leading, 25)
//            ProgressHeader()
//            Image(systemName: "gearshape.fill")
//                .font(.system(size: 22))
//                .foregroundColor(.white)
//                .shadow(color: .black, radius: 5)
//                .frame(maxWidth: .infinity, alignment: .trailing)
//                .padding(.trailing, 25)
//        }
//    }
//}

struct Timeline: View {
    @EnvironmentObject var timelineData: TimelineData
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ZStack {
                    GeometryReader { geo in
                        VStack(spacing: 0) {
                            ForEach(timelineData.days.indices, id: \.self) { i in
                                let index = timelineData.days.count - i - 1
                                let titleSide: Side = index.isMultiple(of: 2) ? .left : .right
                                let model = DayView.ViewModel(index: index, titleSide: titleSide, weatherModel: timelineData.weatherModel)
                                DayView(model: model, day: $timelineData.days[index], editData: $timelineData.editData)
                                    .id("day\(timelineData.days.count - index)")
                                    .frame(height: timelineData.days[index].height)
                            }
                            Spacer().frame(height: 0)
                                .id("bottom")
                        }
                    }
                    
                    TrajectView()
                }
                .padding(.top, 50)
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
                Text("Back")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            
            Button(action: {
                withAnimation {
                    timelineData.nextEvent()
                }
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }) {
                Text("Next")
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
        MainView(timelineData: TimelineData(days: generateDummyWeek()))
    }
}
