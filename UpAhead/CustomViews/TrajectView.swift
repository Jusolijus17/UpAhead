//
//  TrajectView.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-05.
//

import SwiftUI

struct TrajectView: View {
    @EnvironmentObject var timelineData: TimelineData
    var validatedDay: Int {
        get {
            if timelineData.currentDayIndex < 0 {
                return 0
            } else if timelineData.currentDayIndex > timelineData.days.count {
                return timelineData.days.count
            } else {
                return timelineData.currentDayIndex
            }
        }
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color(hex: "E5E5E5"))
                
//                let rectHeight = (geometry.size.height - 10) * (CGFloat(validatedDay) / CGFloat(days.count))
                VStack(spacing: 0) {
                    ForEach(0..<timelineData.days.count, id: \.self) { i in
                        RoadSection(titleSide: i.isMultiple(of: 2) ? .left : .right, day: $timelineData.days[i])
                            .frame(width: 41, height: CGFloat(timelineData.days[i].height))
                    }
                }
                .padding(.top, 10)
                .offset(x: -6)
                
                VStack {
                    if validatedDay != timelineData.days.count {
                        Spacer()
                    }
                    RoundedRectangle(cornerRadius: 12.5)
                        .foregroundColor(.blue)
                        .overlay(
                            VStack {
                                DirectionPointer(radius: geometry.size.width * 0.8)
                                    .offset(x: 0, y: -geometry.size.width * 0.4)
                                Spacer()
                            }
                        )
                        .frame(width: geometry.size.width - 10, height: timelineData.trajectHeight)
                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 0))
                }
            }
            .frame(width: 30, height: timelineData.totalHeight)
        }
    }
}

func calculateRectHeight(days: [Day], currentDayIndex: Int) -> CGFloat {
    var height: CGFloat = -10
    for day in days[0..<currentDayIndex] {
        height += day.height
    }
    return height
}

struct RoadSection: View {
    let titleSide: Side
    @Binding var day: Day
    @State private var eventCount: Int = 0
    
    var body: some View {
        VStack {
            TimeMark(side: titleSide)
                .foregroundColor(.gray)
            Spacer()
            if eventCount != 0 {
                ForEach(0..<eventCount, id: \.self) { i in
                    TimeMark(side: i.isMultiple(of: 2) ? titleSide : titleSide.opposite, secondaryMark: true)
                        .foregroundColor(.yellow)
                    Spacer()
                }
            } else {
                Spacer()
            }
        }
        .onAppear {
            eventCount = day.events.count
        }
        .onChange(of: $day.events.count, perform: { newValue in
            eventCount = newValue
        })
        .padding(.bottom, 5)
    }
}

struct TimeMark: View {
    let side: Side
    let secondaryMark: Bool
    
    init(side: Side, secondaryMark: Bool = false) {
        self.side = side
        self.secondaryMark = secondaryMark
    }
    
    var body: some View {
        let padding: CGFloat = secondaryMark ? 25 : 15
        HStack(spacing: 0) {
            if side == .left {
                Rectangle()
                    .frame(width: secondaryMark ? 50 : 30, height: 2)
                Circle()
                    .frame(width: 12)
            } else {
                Circle()
                    .frame(width: 12)
                Rectangle()
                    .frame(width: secondaryMark ? 50 : 30, height: 2)
            }
        }
        .offset(x: side == .left ? -padding : padding)
    }
}

//struct TimeMark: View {
//    let side: Side
//    let secondaryMark: Bool
//
//    init(side: Side, secondaryMark: Bool = false) {
//        self.side = side
//        self.secondaryMark = secondaryMark
//    }
//
//    var body: some View {
//        let indicatorWidth: CGFloat = secondaryMark ? 60 : 30
//        HStack(spacing: 0) {
//            if side == .left {
//                Rectangle()
//                    .frame(width: indicatorWidth, height: 2)
//                Image(systemName: "circle.fill")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 12)
//            } else {
//                Image(systemName: "circle.fill")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 12)
//                Rectangle()
//                    .frame(width: indicatorWidth, height: 2)
//            }
//        }
//        .offset(x: side == .left ? -21 + 6 : 21 - 6)
//    }
//}

struct DirectionPointer: View {
    let radius: CGFloat
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Circle()
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                
                let padding = (geometry.size.width * 0.15) / 2
                
                Circle()
                    .foregroundColor(.blue)
                    .frame(width: geometry.size.width * 0.85)
                    .padding(EdgeInsets(top: padding, leading: padding, bottom: 0, trailing: 0))
                    .overlay(
                        Image(systemName: "location.north.fill")
                            .font(.system(size: geometry.size.width * 0.6))
                            .foregroundColor(.white)
                            .offset(x: geometry.size.width * 0.05, y: geometry.size.width * 0.05)
                    )
                
                
            }
            .frame(width: radius * 2, height: radius * 2)
        }
    }
}


struct TrajectView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            TrajectView()
                .frame(maxWidth: .infinity)
                .environmentObject(TimelineData(days: generateWeek(), currentDayIndex: 0))
        }
    }
}
