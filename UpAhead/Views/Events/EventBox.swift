//
//  EventBox.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-07.
//

import SwiftUI

struct EventBox: View {
    @Binding var event: Event
    @Binding var isEditing: Bool
    
    var deleteEvent: (() -> Void)?
    
    var body: some View {
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
            .blur(radius: event.isCompleted ? 5 : 0)
            
            if event.isCompleted {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 55))
                    .foregroundColor(event.color == .green ? .blue : .green)
            }
        }
        .shouldWiggle($isEditing)
        .frame(width: Constants.eventBoxWidth, height: Constants.eventBoxHeight)
        .onTapGesture(count: 2) {
            withAnimation {
                event.toggleComplete()
            }
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
        }
    }
}

struct AddBox: View {
    var onTap: () -> Void
    var body: some View {
        Button {
            onTap()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
                    .frame(width: 99, height: 99)
                
                Image(systemName: "plus")
                    .font(.system(size: 40))
            }
            .frame(width: 100, height: 100)
            .foregroundColor(.gray)
        }
    }
}

struct EventBox_Previews: PreviewProvider {
    static var previews: some View {
        let dummyEvent = Event(title: "Test", iconName: "plus", color: .blue, isCompleted: true)
        EventBox(event: .constant(dummyEvent), isEditing: .constant(true), deleteEvent: {})
            .previewLayout(.fixed(width: 175, height: 150))
        AddBox(onTap: {
            
        })
        .previewLayout(.fixed(width: 150, height: 150))
    }
}
