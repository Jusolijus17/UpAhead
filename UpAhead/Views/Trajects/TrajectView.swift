//
//  TrajectView.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-05.
//

import SwiftUI

struct TrajectView: View {
    @EnvironmentObject var timelineData: TimelineData
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Capsule()
                .fill(.secondary)
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .opacity(0.95)
                .frame(width: Constants.trajectWidth)
                .padding([.top, .bottom], 5)
            
            VStack(spacing: 0) {
                ForEach(timelineData.days.indices, id: \.self) { i in
                    RoadSection(index: i)
                        .frame(height: timelineData.days[i].height)
                }
            }
            
            ZStack(alignment: .top) {
                let currentHeight: CGFloat = timelineData.currentDayIndex != 0 ? timelineData.trajectHeight - 50 : timelineData.trajectHeight
                Capsule()
                    .foregroundColor(.blue)
                    .padding(.vertical, 10)
                    .frame(width: Constants.trajectWidth - 10, height: currentHeight)
                
                VStack {
                    DirectionPointer()
                    CurrentTime()
                }
            }
        }
        .environmentObject(timelineData)
    }
}

struct RoadSection: View {
    @EnvironmentObject var timelineData: TimelineData
    let index: Int
    
    var body: some View {
        let day = timelineData.days[index]
        let titleSide: Side = index.isMultiple(of: 2) ? .left : .right
        VStack(spacing: 0) {
            TimeMark(side: titleSide)
                .foregroundColor(.gray)
                .frame(height: 50)
                .id("mark\(index)")
            if day.events.count != 0 {
                VStack(spacing: 0) {
                    Spacer()
                    ForEach(day.events) { event in
                        TimeMark(side: event.index.isMultiple(of: 2) ? titleSide : titleSide.opposite, secondaryMark: true)
                            .foregroundColor(event.color)
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
    
    private func rectangleWidth(geo: GeometryProxy) -> CGFloat {
        var width: CGFloat = (geo.size.width / 2)
        width -= circleOffset
        width -= Constants.listHorizontalPadding
        width -= Constants.dayViewHorizontalPadding
        width -= Constants.eventBoxWidth
        return secondaryMark ? width : 30
    }
    
    private var circleOffset: CGFloat = 6
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                if side == .left {
                    Rectangle()
                        .frame(width: rectangleWidth(geo: geo), height: 2)
                    Circle()
                        .frame(width: 12)
                } else {
                    Circle()
                        .frame(width: 12)
                    Rectangle()
                        .frame(width: rectangleWidth(geo: geo), height: 2)
                }
            }
            .padding(side == .left ? .trailing : .leading, (geo.size.width / 2) - circleOffset)
            .frame(maxWidth: .infinity, alignment: side == .left ? .trailing : .leading)
            .frame(maxHeight: .infinity)
        }
    }
}

struct DirectionPointer: View {
    @Binding var successMark: Bool
    
    init(successMark: Binding<Bool>) {
        self._successMark = successMark
    }
    
    init(successMark: Bool = false) {
        self._successMark = Binding.constant(successMark)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.white)
                .shadow(radius: 5)
            Circle()
                .padding(4)
                .foregroundColor(successMark ? .green : .blue)
            Image(systemName: successMark ? "checkmark" : "location.north.fill")
                .font(.system(size: 28))
                .foregroundColor(.white)
        }
        .frame(width: 50)
    }
}

struct CurrentTime: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var date = Date()
    
    var body: some View {
        Text(convertDate())
            .font(.system(size: 18, weight: .semibold, design: .rounded))
            .frame(width: 80)
            .foregroundColor(Color.accentColor)
            .padding(5)
            .background(
                Capsule()
                    .fill(.white)
            )
            .overlay(
                Capsule()
                    .stroke(Color.accentColor, lineWidth: 2.5)
            )
            .onReceive(timer) { (input) in
                self.date = Date()
            }
    }
    
    func convertDate() -> String {
        let formater = DateFormatter()
        formater.timeZone = .current
        formater.dateFormat = "h:mm:ss"
        return formater.string(from: self.date)
    }
}

struct TrajectView_Previews: PreviewProvider {
    static var previews: some View {
        let timelineData = TimelineData(days: generateDummyWeek(), currentDayIndex: 4)
        ScrollView {
            TrajectView()
                .frame(maxWidth: .infinity)
                .environmentObject(timelineData)
        }
    }
}
