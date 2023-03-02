//
//  EventBox.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-07.
//

import SwiftUI

struct EventBox: View {
    let event: Event
    
    var body: some View {
        HStack(spacing: 0) {
            if event.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.green)
                    .frame(width: 20)
                    .padding(.trailing, 5)
                    .padding(.leading, -25)
            }
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(event.color)
                VStack {
                    Image(systemName: event.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    Text(event.title == "" ? "Ajouter un titre..." : event.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(width: 100, height: 100)
        }
    }
}

struct AddBox: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
            
            Image(systemName: "plus")
                .font(.system(size: 40))
        }
        .frame(width: 100, height: 100)
        .foregroundColor(.gray)
    }
}

struct EventBox_Previews: PreviewProvider {
    static var previews: some View {
        let dummyEvent = Event(title: "Test", iconName: "plus", color: .blue, isCompleted: true)
        EventBox(event: dummyEvent)
            .previewLayout(.fixed(width: 175, height: 150))
        AddBox()
            .previewLayout(.fixed(width: 150, height: 150))
    }
}
