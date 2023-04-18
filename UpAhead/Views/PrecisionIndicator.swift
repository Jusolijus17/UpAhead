//
//  PrecisionIndicator.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-04-08.
//

import SwiftUI

struct PrecisionIndicator: View {
    var currentPourcentage: Double
    let magnification: CGFloat
    let alignement: HorizontalAlignment
    
    init(currentPourcentage: Double, magnification: CGFloat = 1, alignement: HorizontalAlignment = .leading) {
        self.currentPourcentage = currentPourcentage
        self.magnification = magnification
        self.alignement = alignement
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: alignement, spacing: 15) {
                ForEach(0..<Int(geometry.size.height / 18), id: \.self) { index in
                    Rectangle()
                        .frame(width: self.rectWidth(at: index, in: geometry), height: 3)
                }
            }
            .frame(maxHeight: .infinity, alignment: .center)
            .frame(maxWidth: .infinity, alignment: Alignment(horizontal: alignement, vertical: .center))
        }
        .ignoresSafeArea()
    }
    
    private func currentIndex(in geometry: GeometryProxy) -> Int {
        let index = Double(100 - currentPourcentage) / 100 * Double(geometry.size.height) / 18
        return Int(index)
    }
    
    private func scaleFactor(for index: Int, currentIndex: Int) -> CGFloat {
        let diff = CGFloat(abs(index - currentIndex))
        if diff == 0 { return 4 }
        return max(3 / diff, 1)
    }
    
    private func rectWidth(at index: Int, in geometry: GeometryProxy) -> CGFloat {
        let currentIndex = self.currentIndex(in: geometry)
        let scaleFactor = self.scaleFactor(for: index, currentIndex: currentIndex)
        let width = 20 * scaleFactor * magnification
        return width
    }
}


struct PrecisionIndicator_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            HStack(alignment: .bottom) {
                PrecisionIndicator(currentPourcentage: 12.5)
                    .previewLayout(.fixed(width: 150, height: 650))
                Rectangle()
                    .frame(height: geo.size.height * 0.25)
            }
        }
    }
}
