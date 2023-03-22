//
//  SignUpTraject.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-21.
//

import SwiftUI

struct SignUpTraject: View {
    @EnvironmentObject var signUpData: SignUpData
    
    var completedTraject: CGFloat {
        var height: CGFloat = 0
        let stepHeight: CGFloat = signUpData.trajectHeight / CGFloat(signUpData.numberOfSteps)
        for i in 0...signUpData.currentStep {
            if i == 1 {
                height += stepHeight / 2
            } else if i != 0 && i <= signUpData.numberOfSteps {
                height += stepHeight
            } else if i > signUpData.numberOfSteps {
                height = signUpData.trajectHeight
            }
        }
        return height
    }
    
    var body: some View {
        let stepHeight: CGFloat = signUpData.trajectHeight / CGFloat(signUpData.numberOfSteps)
        
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color(hex: "E5E5E5"))
                        .frame(maxWidth: 30)
                }
                
                VStack(spacing: 0) {
                    ForEach(0..<signUpData.numberOfSteps, id: \.self) { index in
                        FieldMark()
                            .frame(height: stepHeight)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                HStack {
                    Spacer()
                    
                    ZStack(alignment: .top) {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.blue)
                            .padding(.vertical, 5)
                            .frame(width: 20, height: completedTraject)
                        
                        DirectionPointer(radius: 25)
                            .id("pointer")
                    }
                    .frame(width: 30)
                }
            }
        }
        .padding()
    }
}

struct FieldMark: View {
    @EnvironmentObject var signUpData: SignUpData
    @State var markWidth: CGFloat = .infinity
    
    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .frame(maxWidth: markWidth, maxHeight: 1.5)
            
            Circle()
                .frame(maxWidth: 12)
        }
        .offset(x: -9, y: 25)
        .padding(.leading)
        .foregroundColor(signUpData.isEditing ? .white : .gray)
        .onChange(of: signUpData.currentStep) { newValue in
            withAnimation {
                markWidth = 10
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    markWidth = .infinity
                }
            }
        }
    }
}

struct SignUpTraject_Previews: PreviewProvider {
    static var previews: some View {
        let signUpData = SignUpData(numberOfSteps: 4)
        
        GeometryReader { geo in
            let trajectHeight: CGFloat = geo.size.height * CGFloat(signUpData.numberOfSteps)
            ScrollViewReader { proxy in
                ScrollView {
                    SignUpTraject()
                        .frame(height: UIScreen.main.bounds.height * CGFloat(signUpData.numberOfSteps))
                        .environmentObject(signUpData)
                        .onAppear {
                            signUpData.trajectHeight = trajectHeight
                        }
                }
                .onAppear {
                    proxy.scrollTo("pointer")
                    signUpData.currentStep = 1
                }
                .onChange(of: signUpData.currentStep) { newValue in
                    proxy.scrollTo("pointer")
                }
            }
        }
    }
}