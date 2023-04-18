//
//  TrajectViewModel.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-04-06.
//

import Foundation
import SwiftUI
import Combine

class ProgressManager: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    //@Published var changeDay: Bool = false
    @Published var pourcentage: Double = 0.0
    
    private var timelineData: TimelineData
    private var observer: AnyCancellable?
    
    init(timelineData: TimelineData) {
        self.timelineData = timelineData
        
        self.observer = timelineData.$days.sink(receiveValue: {[weak self] _ in
            self?.updateHeight()
        })
    }
    
    func updateHeight() {
        print("Received an update from timelineData! Here :\(timelineData.days[0].events[0].isCompleted)")
    }
    
//    func setup(_ timelineData: TimelineData) {
//        self.currentDayHeight = timelineData.getCurrentDay().height
//        self.heightInterval = currentDayHeight / secondsInDay
//        self.secondsElapsed = secondsSinceMidnight()
//        self.pourcentage = (secondsSinceMidnight() / secondsInDay) * 100 - 4
//        self.setCurrentHeight()
        
//        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
//            self.updateValues()
//        })
//    }
    
//    private func setCurrentHeight() {
//        addedHeight = heightInterval * CGFloat(secondsSinceMidnight())
//    }
    
//    private func updateValues() {
//        print(secondsSinceMidnight())
//        if secondsElapsed != secondsInDay - 1 {
//            withAnimation {
//                addedHeight += heightInterval
//                pourcentage = (secondsInDay / secondsSinceMidnight()) * 100 - 4
//            }
//            secondsElapsed += 1
//        } else {
//            print("Equal")
//            changeDay.toggle()
//            changeDay.toggle()
//            secondsElapsed = 0
//        }
//    }
    
//    private func secondsSinceMidnight() -> Double {
//        let calendar = Calendar.current
//        let now = Date()
//        let midnight = calendar.startOfDay(for: now)
//        let seconds = calendar.dateComponents([.second], from: midnight, to: now).second ?? 0
//        return Double(seconds)
//    }
    
}

struct ProgressBarView: View {
    @State var progress = 0.0
    
    var body: some View {
        let now = Date()
        let secondsInDay: Double = 86_400
        let startOfDay = Calendar.current.startOfDay(for: now)
        let secondsSinceMidnight = now.timeIntervalSince(startOfDay)
        
        ProgressView(value: progress)
            .onAppear {
                progress = secondsSinceMidnight / secondsInDay
            }
            .accentColor(/*@START_MENU_TOKEN@*/.green/*@END_MENU_TOKEN@*/)
    }
}

struct ProgressBarPreview: PreviewProvider {
    static var previews: some View {
        ProgressBarView()
            .previewLayout(.fixed(width: 200, height: 30))
    }
}
