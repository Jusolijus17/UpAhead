import SwiftUI

struct ContentView: View {
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    let tasks = [
        ["Task 1", "Task 2", "Task 3"],
        ["Task 4", "Task 5", "Task 6"],
        ["Task 7", "Task 8", "Task 9"],
        ["Task 10", "Task 11", "Task 12"],
        ["Task 13", "Task 14", "Task 15"],
        ["Task 16", "Task 17", "Task 18"],
        ["Task 19", "Task 20", "Task 21"]
    ]
    
    var body: some View {
        ScrollView {
            ZStack {
                List(0..<daysOfWeek.count) { index in
                    DayRect(day: .constant(generateDay()), index: index, titleSide: .left, editData: .constant(EditData()))
                }
                .ignoresSafeArea()
                
                TrajectView()
                    .environmentObject(TimelineData(days: generateDummyWeek(), currentDayIndex: 3))
            }
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }
}

struct RoadView: View {
    var body: some View {
        // Your road view implementation here
        Text("Road view")
    }
}

struct Test_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
