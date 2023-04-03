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
                    .environmentObject(TimelineData(days: generateDummyWeek(), currentDayIndex: 3))
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

struct Test_Preview: PreviewProvider {
    static var previews: some View {
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        let signUpData: SignUpData = SignUpData(numberOfSteps: 4)
        let state: AnimationState = AnimationState()
        ScrollViewReader { proxy in
            ScrollView {
                RoadView()
                    .frame(height: screenHeight * CGFloat(signUpData.numberOfSteps))
                    .environmentObject(signUpData)
                    .environmentObject(state)
            }
            .onAppear {
                proxy.scrollTo("pointer")
                withAnimation {
                    state.currentCursorStep = 1
                }
            }
            .ignoresSafeArea()
        }
    }
}
