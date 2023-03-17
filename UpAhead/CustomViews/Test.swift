import SwiftUI

struct Event2: Identifiable {
    let id = UUID()
    let name: String
    let date: Date
}

struct EventListView: View {
    let events: [Event2]

    var body: some View {
        HStack {
            LeftVStack(events: events)
            RightVStack(events: events)
        }
    }

    struct LeftVStack: View {
        let events: [Event2]

        var body: some View {
            VStack(spacing: 100) {
                ForEach(events.indices.filter { $0 % 2 == 0 }, id: \.self) { index in
                    EventBox(event: Event(title: "", iconName: "", color: .blue, isCompleted: false), side: .left)
                }
                if events.count.isMultiple(of: 2) {
                    Spacer().frame(height: 0)
                }
            }
        }
    }

    struct RightVStack: View {
        let events: [Event2]

        var body: some View {
            VStack(spacing: 100) {
                if events.count.isMultiple(of: 2) {
                    Spacer().frame(height: 0)
                }
                ForEach(events.indices.filter { $0 % 2 == 1 }, id: \.self) { index in
                    EventBox(event: Event(title: "", iconName: "", color: .blue, isCompleted: false), side: .right)
                }
            }
        }
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        let events = [
            Event2(name: "Event 1", date: Date()),
            Event2(name: "Event 2", date: Date().addingTimeInterval(3600)),
            Event2(name: "Event 3", date: Date().addingTimeInterval(7200)),
            Event2(name: "Event 4", date: Date().addingTimeInterval(10800)),
            Event2(name: "Event 5", date: Date().addingTimeInterval(14400)),
            Event2(name: "Event 5", date: Date().addingTimeInterval(14400))
        ]
        EventListView(events: events)
            .frame(height: 400)
    }
}

struct TestTraject: View {
    @State var trajectHeight: CGFloat
    @Binding var days: [Day]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color(hex: "E5E5E5"))
            
            VStack(spacing: 0) {
                ForEach(days.indices, id: \.self) { i in
                    RoadSection(titleSide: i.isMultiple(of: 2) ? .left : .right, day: $days[i], index: i)
                        .frame(height: days[i].height)
                }
            }
            .frame(width: 30)
            
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.blue)
                    .padding(.vertical, 5)
                    .frame(width: 20, height: trajectHeight)
                
                DirectionPointer(radius: 20)
            }
            .frame(width: 30)
        }
        .frame(width: 30)
        
    }
}

struct TestTrajectPreview: PreviewProvider {
    static var previews: some View {
        ScrollView {
            TestTraject(trajectHeight: 200, days: .constant(generateWeek()))
                .frame(maxWidth: .infinity)
        }
    }
}
