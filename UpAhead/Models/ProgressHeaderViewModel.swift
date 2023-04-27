//
//  ProgressHeaderViewModel.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-04-27.
//

import SwiftUI

extension ProgressHeader {
    @MainActor class ViewModel: ObservableObject {
        @Published var percentState = ProgressPercentState()
        @Published var currentPercent: Int = 0
        @Published var isExpanded: Bool = false
        @Published var width: CGFloat = 200
        @Published var height: CGFloat = 50
        @Published var lateList: [(String, Int)] = []
        
        func updatePercent(_ newValue: Double) {
            currentPercent = Int(round(newValue))
            percentState.showCurrentPercent = true
            let item = DispatchWorkItem {
                withAnimation {
                    self.percentState.showCurrentPercent = false
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: item)
            percentState.previousWorkItem?.cancel()
            percentState.previousWorkItem = item
        }
        
        func onTap(timelineData: TimelineData) {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            percentState.showCurrentPercent = true
            
            if !timelineData.isUpToDate {
                lateList = timelineData.getLateEventsList()
                if !isExpanded {
                    withAnimation(Animation.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0)) {
                        width = 300
                        height += CGFloat(lateList.count * 20) + 18
                    }
                    withAnimation {
                        isExpanded = true
                    }
                }
            }
            
            let item = DispatchWorkItem {
                withAnimation {
                    self.percentState.showCurrentPercent = false
                    self.isExpanded = false
                    self.width = 200
                    self.height = 50
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
