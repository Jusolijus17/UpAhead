//
//  ProgressView.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-04-24.
//

import SwiftUI

struct ProgressHeader: View {
    @EnvironmentObject var timelineData: TimelineData
    @State var percentState = ProgressPercentState()
    
    @State var currentPercent: Int = 0
    
    var body: some View {
        let percent = round(timelineData.currentDay.completionPercent)
        let normalizedPercent = percent / 100
        let fillAmount = CGFloat(normalizedPercent * 200)
        ZStack() {
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.accentColor)
                    .frame(width: 200, height: 50)
                Group {
                    Rectangle()
                        .fill(.green)
                        .frame(width: fillAmount, height: 40)
                }
                .frame(width: 200, alignment: .leading)
                .mask {
                    Capsule()
                        .frame(width: 190, height: 40)
                }
            }
            RollingText(font: .system(size: 32, weight: .bold, design: .rounded), value: $currentPercent)
                .foregroundColor(.white)
                .opacity(percentState.showCurrentPercent ? 1 : 0)
            if !percentState.showCurrentPercent {
                Text(Constants.appName)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .cornerRadius(20)
                    .shadow(radius: 10)
            }
        }
        .shadow(radius: 10)
        .onChange(of: timelineData.currentDay.completedEventsCount) { newValue in
            percentState.showCurrentPercent = true
            let item = DispatchWorkItem {
                withAnimation {
                    percentState.showCurrentPercent = false
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: item)
            percentState.previousWorkItem?.cancel()
            percentState.previousWorkItem = item
        }
        .onChange(of: timelineData.currentDay.completionPercent) { newValue in
            currentPercent = Int(round(newValue))
        }
        .onTapGesture {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            percentState.showCurrentPercent = true
            let item = DispatchWorkItem {
                withAnimation {
                    percentState.showCurrentPercent = false
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: item)
            percentState.previousWorkItem?.cancel()
            percentState.previousWorkItem = item
        }
    }
    
    struct ProgressPercentState {
        var showCurrentPercent = false
        var previousWorkItem: DispatchWorkItem? {
            didSet {
                if let previousItem = oldValue {
                    previousItem.cancel()
                }
            }
        }
    }
}

struct ProgressHeader_Previews: PreviewProvider {
    static var previews: some View {
        let timelineData: TimelineData = TimelineData()
        ProgressHeader()
            .environmentObject(timelineData)
    }
}
