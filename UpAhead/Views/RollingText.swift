//
//  RollingText.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-04-25.
//

import SwiftUI

struct RollingText: View {
    var font: Font = .largeTitle
    @Binding var value: Int
    @State var animationRange: [Int] = []
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<animationRange.count, id: \.self){ index in
                // MARK: To Find Text Size for Given Font
                // Random Number
                Text("8")
                    .font(font)
                    .opacity(0)
                    .overlay {
                        GeometryReader{ proxy in
                            let size = proxy.size
                            VStack(spacing: 0){
                                // MARK: Since Its Individual Value
                                // We Need From 0-9
                                ForEach(0...9,id: \.self) { number in
                                    Text("\(number)")
                                        .font(font)
                                        .frame(width: size.width, height: size.height, alignment: .center)
                                }
                            }
                            .offset(y: -CGFloat(animationRange[index]) * size.height)
                        }
                        .clipped()
                    }
            }
            .onChange(of: value) { newValue in
                let extra = "\(value)".count - animationRange.count
                if extra > 0 {
                    for _ in 0..<extra {
                        withAnimation(.easeIn(duration: 0.1)) {
                            animationRange.append(0)
                        }
                    }
                } else {
                    for _ in 0..<(-extra) {
                        withAnimation(.easeIn(duration: 0.1)) {
                            let _ = animationRange.removeLast()
                        }
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    updateText()
                }
            }
        }
        .onAppear {
            let value = "\(value)".count
            let count = value == 0 ? 1 : value
            animationRange = Array(repeating: 0, count: count)
            updateText()
        }
    }
    
    func updateText() {
        let stringValue = "\(value)"
        for (index, value) in zip(0..<stringValue.count, stringValue) {
            var fraction = Double(index) * 0.15
            fraction = (fraction > 0.5 ? 0.5 : fraction)
            withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 1 + fraction, blendDuration: 1 + fraction)) {
                animationRange[index] = (String(value) as NSString).integerValue
            }
        }
    }
}
