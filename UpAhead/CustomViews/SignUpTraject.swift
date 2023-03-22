//
//  SignUpTraject.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-21.
//

import SwiftUI

struct SignUpTraject: View {
    @Binding var currentStep: Int
    @Binding var numberOfSteps: Int
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color(hex: "E5E5E5"))
                
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.blue)
                        .padding(.vertical, 5)
                        .frame(width: 20, height: ((geo.size.height) / CGFloat(numberOfSteps)) * CGFloat(currentStep))
                    
                    DirectionPointer(radius: 25)
                        .id("pointer")
                }
                .frame(width: 30)
            }
        }
        .frame(width: 30)
    }
}

struct SignUpTraject_Previews: PreviewProvider {
    static var previews: some View {
        SignUpTraject(currentStep: .constant(3), numberOfSteps: .constant(10))
    }
}
