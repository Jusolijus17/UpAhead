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
                List(0..<daysOfWeek.count, id: \.self) { index in
                    let model = DayView.ViewModel(index: index, titleSide: .left, weatherModel: WeatherModel())
                    DayView(model: model, day: .constant(generateDay()), editData: .constant(EditData()))
                }
                .ignoresSafeArea()
                
                TrajectView()
                    .environmentObject(TimelineData(days: generateDummyWeek()))
            }
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }
}

struct RoadView: View {
    @EnvironmentObject var signUpData: SignUpData
    @EnvironmentObject var state: AnimationState
    
    var body: some View {
        GeometryReader { geo in
            let multiplier: CGFloat = (CGFloat(state.currentCursorStep) * 2 - 1) / (CGFloat(signUpData.numberOfSteps) * 2)
            let currentHeight: CGFloat = geo.size.height * multiplier
            let normalizedHeight: CGFloat = state.currentCursorStep > signUpData.numberOfSteps ? geo.size.height - 10 : currentHeight
            let stepHeight: CGFloat = geo.size.height / CGFloat(signUpData.numberOfSteps)
            ZStack(alignment: .bottom) {
                Capsule()
                    .foregroundColor(.gray.opacity(0.3))
                    .frame(width: 30)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                VStack(spacing: 0) {
                    ForEach(0..<signUpData.numberOfSteps, id: \.self) { i in
                        FieldMark()
                            .frame(height: stepHeight)
                    }
                }
                
                ZStack(alignment: .top) {
                    Capsule()
                        .foregroundColor(.blue)
                        .frame(width: 20, height: normalizedHeight <= 40 ? 40 : normalizedHeight)
                        .padding(.vertical, 5)
                    
                    
                    DirectionPointer()
                        .id("pointer")
                        .frame(width: 50)
                }
                .offset(x: 10)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal)
        }
    }
}

struct VerticalBarView: View {
    var percentage: Double

    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<Int(percentage / 10)) { index in
                HorizontalBarView(scale: computeScale(index: index, percentage: percentage))
            }
        }
        .frame(width: 10, height: 200)
        .background(Color.gray)
        .cornerRadius(5)
    }

    private func computeScale(index: Int, percentage: Double) -> Double {
        let maxScale = min(percentage / 10, 10)
        let diff = abs(Double(index) - maxScale / 2)
        let scale = 1.0 + (1 - diff / (maxScale / 2)) * 0.5
        return scale
    }
}

struct HorizontalBarView: View {
    var scale: Double

    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .frame(width: geometry.size.width * CGFloat(scale), height: 5)
                .foregroundColor(Color.green)
        }
    }
}

struct ListTest: View {
    @State var items = ["Item 1", "Item 2", "Item 3", "Item 4"]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.self) { item in
                    //EventRow()
                }
                .onMove(perform: move)
                .listRowSeparator(.hidden)
            }
            .navigationBarTitle("My List")
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }
}

struct ListTest2: View {
    @State var items = ["Item 1", "Item 2", "Item 3"]

    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Image(systemName: "line.horizontal.3")
                            .foregroundColor(.gray)
                        Text(item)
                    }
                    .listRowBackground(Color.white)
                }
                .onMove(perform: move)
            }
            .navigationTitle("List Demo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }

    func move(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }
}

struct ZStackTest: View {
    var body: some View {
        ZStack {
            Demo()
            Rectangle()
                .fill(Color.red)
                .frame(width: 200, height: 50)
                .zIndex(0)
        }
    }
}

struct Demo: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
            Circle()
                .fill(.white)
                .frame(width: 100)
                .zIndex(1)
        }
    }
}



struct Test_Preview: PreviewProvider {
    static var previews: some View {
//        let screenHeight: CGFloat = UIScreen.main.bounds.height
//        let signUpData: SignUpData = SignUpData(numberOfSteps: 4)
//        let state: AnimationState = AnimationState()
//        ScrollViewReader { proxy in
//            ScrollView {
//                RoadView()
//                    .frame(height: screenHeight * CGFloat(signUpData.numberOfSteps))
//                    .environmentObject(signUpData)
//                    .environmentObject(state)
//            }
//            .onAppear {
//                proxy.scrollTo("pointer")
//                withAnimation {
//                    state.currentCursorStep = 1
//                }
//            }
//            .ignoresSafeArea()
//        }
        ZStackTest()
    }
}
