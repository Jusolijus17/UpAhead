//
//  CreateEventView.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-08.
//

import SwiftUI
import Combine

struct CreateEventView: View {
    @EnvironmentObject var timelineData: TimelineData
    @State var selectedIcon: String = "house"
    @State var title: String = ""
    @State private var keyboardHeight: CGFloat = 0
    @State var color: Color = Color.blue
    @Binding var day: Day
    
    var body: some View {
        VStack(spacing: 20) {
            Rectangle()
                .cornerRadius(2)
                .frame(width: 50, height: 4)
                .foregroundColor(.gray)
                .padding(.top, 10)
                .padding(.bottom, -20)
                
            
            Text("Create Event")
                .font(.largeTitle)
                .bold()
            
            EventBox(event: Event(title: title, iconName: selectedIcon, color: color, isCompleted: false), side: .left)
            
            Group {
                TextField("Enter a title", text: $title)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                        withAnimation {
                            self.keyboardHeight = keyboardHeight
                        }
                    }
            }
            .padding(.horizontal, 30)
            
            ColorPickerView(selectedColor: $color)
            
            IconPicker(selectedIcon: $selectedIcon)
            
            Button(action: {
                if title != "" {
                    let newEvent = Event(title: title, iconName: selectedIcon, color: color, isCompleted: false)
                    day.addEvent(newEvent)
                    withAnimation {
                        timelineData.editData.toggleEditor()
                    }
                }
                }) {
                Text("Save")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal, 30)
            }
        }
        .padding(.bottom, 30)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(50)
    }
}

struct ColorPickerView: View {
    let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink, .gray, .black, .white]
    @Binding var selectedColor: Color

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(colors, id: \.self) { color in
                    Button(action: {
                        self.selectedColor = color
                    }) {
                        Circle()
                            .fill(color)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 3)
                                    .opacity(selectedColor == color ? 1 : 0)
                            )
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
    }
}


struct IconPicker: View {
    @Binding var selectedIcon: String
    
    let symbols = [
        "house",
        "person",
        "car",
        "star",
        "flag",
        "music.note",
        "film",
        "book",
        "doc",
        "folder",
        "paperplane",
        "pencil",
        "trash",
        "heart",
        "moon.stars",
        "sun.max",
        "globe",
        "gear",
        "wrench",
        "clock",
        "bolt",
        "battery.100",
        "waveform",
        "antenna.radiowaves.left.and.right"
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                ForEach(symbols, id: \.self) { symbolName in
                    Button(action: {
                        self.selectedIcon = symbolName
                    }) {
                        Image(systemName: symbolName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(symbolName == selectedIcon ? .blue : .gray)
                            .frame(width: 40, height: 40)
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 150)
    }
}




struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventView(day: .constant(generateDay()))
            .background(.blue)
    }
}
