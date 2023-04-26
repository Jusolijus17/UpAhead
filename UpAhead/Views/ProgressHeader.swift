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
    
    var progression: CGFloat {
        let percent = round(timelineData.completionPercent)
        let normalizedPercent = percent / 100
        let fillAmount = CGFloat(normalizedPercent * 200)
        return fillAmount
    }
    
    var body: some View {
        ZStack() {
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.accentColor)
                    .frame(width: 200, height: 50)
                Group {
                    Rectangle()
                        .fill(.green)
                        .frame(width: progression, height: 40)
                }
                .frame(width: 200, alignment: .leading)
                .mask {
                    Capsule()
                        .frame(width: 190, height: 40)
                }
            }
            let font = Font.system(size: 32, weight: .bold, design: .rounded)
            RollingText(font: font, value: $currentPercent)
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
        .onAppear {
            currentPercent = Int(round(timelineData.completionPercent))
        }
        .onChange(of: timelineData.completionPercent) { newValue in
            currentPercent = Int(round(newValue))
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
