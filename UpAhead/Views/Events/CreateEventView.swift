//
//  CreateEventView.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-08.
//

import SwiftUI
import Combine

struct CreateEventView: View {
    @StateObject var model = ViewModel()
    @EnvironmentObject var timelineData: TimelineData
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
            
            HStack {
                Spacer()
                EventBox(event: .constant(model.getEvent(date: day.date)), isEditing: .constant(false))
                Spacer()
                    .overlay {
                        DatePicker("Time of event", selection: $model.time, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
            }
            
            TextField("Enter a title", text: $model.title)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal, 30)
                .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                    withAnimation {
                        self.model.keyboardHeight = keyboardHeight
                    }
                }
            
            ColorPickerView()
            
            IconPicker()
            
            Button(action: {
                if model.title != "" {
                    day.addEvent(model.getEvent(date: day.date))
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
        .environmentObject(model)
        .padding(.bottom, 30)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(50)
    }
}

struct ColorPickerView: View {
    @EnvironmentObject var model: CreateEventView.ViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(model.colors, id: \.self) { color in
                    Button(action: {
                        self.model.color = color
                    }) {
                        Circle()
                            .fill(color)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 3)
                                    .opacity(model.color == color ? 1 : 0)
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
    @EnvironmentObject var model: CreateEventView.ViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                ForEach(model.symbols, id: \.self) { symbolName in
                    Button(action: {
                        self.model.selectedIcon = symbolName
                    }) {
                        Image(systemName: symbolName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(symbolName == model.selectedIcon ? .blue : .gray)
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
        ZStack(alignment: .bottom) {
            Color.accentColor
            CreateEventView(day: .constant(generateDay()))
        }
        .ignoresSafeArea()
    }
}
