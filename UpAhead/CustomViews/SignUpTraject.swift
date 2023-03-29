//
//  SignUpTraject.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-21.
//

import SwiftUI

struct SignUpTraject: View {
    @EnvironmentObject var signUpData: SignUpData
    @EnvironmentObject var state: AnimationState
    
    var body: some View {
        GeometryReader { geo in
            let multiplier: CGFloat = (CGFloat(state.currentCursorStep) * 2 - 1) / (CGFloat(signUpData.numberOfSteps) * 2)
            let currentHeight: CGFloat = geo.size.height * multiplier
            let normalizedHeight: CGFloat = state.currentCursorStep > signUpData.numberOfSteps ? geo.size.height - 10 : currentHeight
            let stepHeight: CGFloat = geo.size.height / CGFloat(signUpData.numberOfSteps)
            ZStack(alignment: .bottom) {
                Capsule()
                    .foregroundColor(.gray.opacity(0.3))
                    .frame(width: 30)
                    .frame(maxWidth: .infinity, alignment: state.titleText != "" ? .trailing : .center)
                
                if !state.showSuccess {
                    VStack(spacing: 0) {
                        ForEach(0..<signUpData.numberOfSteps, id: \.self) { i in
                            FieldMark()
                                .frame(height: stepHeight)
                        }
                    }
                }
                
                ZStack(alignment: .top) {
                    Capsule()
                        .foregroundColor(.blue)
                        .frame(width: 20, height: normalizedHeight <= 40 ? 40 : normalizedHeight)
                        .padding(.vertical, 5)
                    
                    
                    DirectionPointer(successMark: $state.showCheckMark)
                        .id("pointer")
                        .frame(width: 50)
                }
                .offset(x: state.titleText != "" ? 10 : 0)
                .frame(maxWidth: .infinity, alignment: state.titleText != "" ? .trailing : .center)
            }
        }
        .padding(20)
    }
}

struct FieldMark: View {
    @EnvironmentObject var signUpData: SignUpData
    @EnvironmentObject var state: AnimationState
    
    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .frame(maxWidth: state.lineWidth, maxHeight: 1.5)
            
            Circle()
                .frame(maxWidth: 12)
        }
        .offset(y: 25)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.leading, 5)
        .padding(.trailing, 9)
        .foregroundColor(state.lineColor)
    }
}

struct SignUpTraject_Previews: PreviewProvider {
    static var previews: some View {
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        let signUpData: SignUpData = SignUpData(numberOfSteps: 4)
        let state: AnimationState = AnimationState()
        ScrollViewReader { proxy in
            ScrollView {
                SignUpTraject()
                    .frame(height: screenHeight * CGFloat(signUpData.numberOfSteps) - 20)
                    .environmentObject(signUpData)
                    .environmentObject(state)
            }
            .onAppear {
                proxy.scrollTo("pointer")
                withAnimation {
                    state.currentCursorStep = 1
                }
            }
            .ignoresSafeArea()
        }
    }
}
