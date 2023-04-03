//
//  Backgrounds.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-31.
//

import SwiftUI

struct RainyDayGradient: View {
    var continuous: Bool = false
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "189CFB"), Color(hex: "1851BE")]),
            startPoint: .top,
            endPoint: .bottom
        )
        .background(.white)
    }
}

struct SunnyDayGradient: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.85)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .background(.white)
    }
}

struct CloudyDayGradient: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "636A8C"), Color(hex: "808AB7")]),
            startPoint: .bottom,
            endPoint: .top
        )
    }
}

struct CloudyDayBackground: View {
    var body: some View {
        ZStack {
            Image("cloud-background")
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            Rectangle()
                .foregroundColor(.secondary)
                .background(.ultraThinMaterial)
                .opacity(0.95)
        }
    }
}

struct BackgroundsPreviews: PreviewProvider {
    static var previews: some View {
        RainyDayGradient()
            .cornerRadius(25)
            .previewLayout(.fixed(width: 600, height: 500))
        SunnyDayGradient()
            .cornerRadius(25)
            .previewLayout(.fixed(width: 600, height: 500))
        CloudyDayBackground()
            .cornerRadius(25)
            .previewLayout(.fixed(width: 600, height: 500))
        CloudyDayGradient()
            .cornerRadius(25)
            .previewLayout(.fixed(width: 600, height: 500))
    }
}
