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
    
//    var body: some View {
//        ZStack {
//            GeometryReader { geometry in
//                RoundedRectangle(cornerRadius: 15)
//                    .foregroundColor(Color(hex: "E5E5E5"))
//                VStack(spacing: 0) {
//                    ForEach(0..<timelineData.days.count, id: \.self) { i in
//                        RoadSection(titleSide: i.isMultiple(of: 2) ? .left : .right, day: $timelineData.days[i], index: i)
//                            .frame(width: 41, height: CGFloat(timelineData.days[i].height))
//                    }
//                }
//                .offset(x: -6)
//
//                VStack {
//
//                    RoundedRectangle(cornerRadius: 12.5)
//                        .foregroundColor(.blue)
//                        .overlay(
//                            VStack {
//                                DirectionPointer(radius: geometry.size.width * 0.8)
//                                    .id("direction")
//                            }
//                        )
//                        .frame(width: geometry.size.width - 10, height: timelineData.trajectHeight, alignment: .bottom)
//                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 0))
//                }
//            }
//            .frame(width: 30, height: timelineData.totalHeight)
//            .padding()
//        }
//    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color(hex: "E5E5E5"))
            
            VStack(spacing: 0) {
                ForEach(timelineData.days.indices, id: \.self) { i in
                    RoadSection(titleSide: i.isMultiple(of: 2) ? .left : .right, day: $timelineData.days[i], index: i)
                        .frame(height: timelineData.days[i].height)
                }
            }
            .frame(width: 30)
            
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.blue)
                    .padding(.vertical, 5)
                    .frame(width: 20, height: timelineData.trajectHeight)
                
                DirectionPointer(radius: 25)
            }
            .frame(width: 30)
        }
        .frame(width: 30)
        
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
    let index: Int
    
    var body: some View {
        VStack(spacing: 0) {
            TimeMark(side: titleSide)
                .foregroundColor(.gray)
                .frame(height: 50)
                .id("mark\(index)")
            if day.events.count != 0 {
                VStack(spacing: 0) {
                    Spacer()
                    ForEach(day.events.indices, id: \.self) { i in
                        TimeMark(side: i.isMultiple(of: 2) ? titleSide : titleSide.opposite, secondaryMark: true)
                            .foregroundColor(day.events[i].color)
                            .frame(height: 100)
                    }
                    Spacer()
                }
            } else {
                Spacer()
            }
        }
    }
}

struct TimeMark: View {
    let side: Side
    let secondaryMark: Bool
    
    init(side: Side, secondaryMark: Bool = false) {
        self.side = side
        self.secondaryMark = secondaryMark
    }
    
    private var rectangleWidth: CGFloat {
        return secondaryMark ? 50 : 30
    }
    
    private var circleOffset: CGFloat {
        return side == .left ? -padding : padding
    }
    
    private var padding: CGFloat {
        return secondaryMark ? 25 : 15
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if side == .left {
                Rectangle()
                    .frame(width: rectangleWidth, height: 2)
                Circle()
                    .frame(width: 12)
            } else {
                Circle()
                    .frame(width: 12)
                Rectangle()
                    .frame(width: rectangleWidth, height: 2)
            }
        }
        .offset(x: circleOffset)
    }
}

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
        let timelineData = TimelineData(days: generateWeek(), currentDayIndex: 3)
        ScrollView {
            TrajectView()
                .frame(maxWidth: .infinity)
                .environmentObject(TimelineData(days: generateWeek(), currentDayIndex: 4))
        }
    }
}
