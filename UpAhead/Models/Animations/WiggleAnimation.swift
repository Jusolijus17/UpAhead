//
//  WiggleAnimation.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-04-02.
//

import Foundation
import SwiftUI

extension View {
    func shouldWiggle(_ wiggle: Binding<Bool>) -> some View {
        modifier(WiggleModifier(shouldWiggle: wiggle))
    }
}

struct WiggleModifier: ViewModifier {
    @Binding var shouldWiggle: Bool
    @State var isWiggling: Bool = false
    
    private static func randomize(interval: TimeInterval, withVariance variance: Double) -> TimeInterval {
        let random = (Double(arc4random_uniform(1000)) - 500.0) / 500.0
        return interval + variance * random
    }
    
    private let rotateAnimation = Animation
        .easeInOut(
            duration: WiggleModifier.randomize(
                interval: 0.14,
                withVariance: 0.025
            )
        )
    
    private let bounceAnimation = Animation
        .easeInOut(
            duration: WiggleModifier.randomize(
                interval: 0.18,
                withVariance: 0.025
            )
        )
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(isWiggling ? 2.0 : 0))
            .onAppear {
                if shouldWiggle {
                    withAnimation(bounceAnimation) {
                        withAnimation(rotateAnimation) {
                            isWiggling.toggle()
                        }
                    }
                }
            }
            .onChange(of: shouldWiggle) { _ in
                withAnimation(bounceAnimation.repeat(while: shouldWiggle, autoreverses: true)) {
                    withAnimation(rotateAnimation.repeat(while: shouldWiggle, autoreverses: true)) {
                        isWiggling.toggle()
                    }
                }
            }
    }
}

extension Animation {
    func `repeat`(while expression: Bool, autoreverses: Bool = true) -> Animation {
        if expression {
            return self.repeatForever(autoreverses: autoreverses)
        } else {
            return self
        }
    }
}
