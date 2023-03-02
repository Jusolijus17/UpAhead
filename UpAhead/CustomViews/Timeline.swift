//
//  Timeline.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-02.
//

import SwiftUI

struct Timeline: View {
    var body: some View {
        let lineHeight: CGFloat = 30
        let spacing: CGFloat = 30 // Espacement entre les rectangles
        
        GeometryReader { geometry in
            let numberOfRectangles = geometry.size.height / (lineHeight + spacing)
            VStack(spacing: spacing) {
                ForEach(0..<Int(numberOfRectangles + 1), id: \.self) { index in
                    Rectangle()
                        .frame(width: 7, height: lineHeight)
                        .foregroundColor(.yellow)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .background(Color.gray)
        .ignoresSafeArea()
    }
}

struct Timeline_Previews: PreviewProvider {
    static var previews: some View {
        Timeline()
            .previewLayout(.fixed(width: 75, height: 1000))
    }
}
