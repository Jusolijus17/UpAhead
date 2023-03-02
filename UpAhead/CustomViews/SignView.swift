//
//  SignView.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-02.
//

import SwiftUI

enum Side {
    case left
    case right
    
    var opposite: Side {
        return self == .left ? .right : .left
    }
}

struct SignView: View {
    let text: String
    let side: Side
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.brown)
                .overlay(
                    Text(text)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                )
                .frame(idealWidth: 20, maxWidth: 100, maxHeight: 50)
            Rectangle()
                .frame(width: 10, height: 35)
                .foregroundColor(.brown)
                .cornerRadius(5)
                .padding(EdgeInsets(top: -5, leading: 0, bottom: 0, trailing: 0))
        }
        .rotationEffect(Angle(degrees: side == .left ? -10 : 10))
    }
    
    func textWidth(for text: String, size: CGFloat = 17) -> CGFloat {
        let font = UIFont.systemFont(ofSize: size)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        return ceil(size.width) + 20 // 20 is the padding of the text
    }
}

struct SignView_Previews: PreviewProvider {
    static var previews: some View {
        SignView(text: "Examen INF2705", side: .left)
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
