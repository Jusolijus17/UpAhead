//
//  CreateAccountPage.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-20.
//

import SwiftUI
import FirebaseAuth

class AnimationState: ObservableObject {
    @Published var lineColor: Color = .gray // DONE
    @Published var lineWidth: CGFloat = 5 // DONE
    @Published var textFieldtext: String = "" // DONE
    @Published var placeholder: String = "What's your email?" // DONE
    @Published var currentCursorStep: Int = 0 // DONE
    @Published var shouldScroll: Bool = false // DONE
    @Published var showSuccess: Bool = false // Change nav icon to checkmark DONE
    @Published var fieldType: SignUpField = .email // DONE
    @Published var isEditing: Bool = false // DONE
    @Published var shouldWelcome: Bool = false
    @Published var titleText: String = "Create an account"
    @Published var showCheckMark: Bool = false
    @Published var showMainView: Bool = false
    @Published var mainViewOpacity: CGFloat = 0.0
}

struct CustomSignUp: View {
    @StateObject var signUpData: SignUpData
    @StateObject private var state = AnimationState()
    
    var body: some View {
        
        ZStack {
            
            if state.showMainView {
                MainView(timelineData: TimelineData())
                    .opacity(state.mainViewOpacity)
            }
            
            if state.mainViewOpacity != 1.1 {
                    NavigationView {
                        ZStack {
                            Color(hex: "394A59")
                                .ignoresSafeArea()
                            
                            VStack {
                                state.showSuccess ? Spacer() : nil
                                Text(state.titleText)
                                    .font(.system(size: 35, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            
                            if !state.showSuccess {
                                SignUpStep(onNext: {
                                    if signUpData.currentStep <= signUpData.numberOfSteps + 1 {
                                        nextStep()
                                    }
                                }, onBack: {
                                    previousStep()
                                })
                                .frame(maxWidth: .infinity)
                            }
                            
                            GeometryReader { geo in
                                let trajectHeight: CGFloat = geo.size.height * CGFloat(signUpData.numberOfSteps)
                                ScrollViewReader { proxy in
                                    ScrollView(showsIndicators: false) {
                                        SignUpTraject()
                                            .frame(height: UIScreen.main.bounds.height * CGFloat(signUpData.numberOfSteps) - 20)
                                    }
                                    .ignoresSafeArea()
                                    .scrollDisabled(true)
                                    .onAppear {
                                        proxy.scrollTo("pointer", anchor: .trailing)
                                    }
                                    .onChange(of: state.shouldScroll) { _ in
                                        if state.showSuccess {
                                            withAnimation(Animation.easeInOut(duration: 2.0)) {
                                                proxy.scrollTo("pointer", anchor: .center)
                                            }
                                        } else {
                                            withAnimation {
                                                proxy.scrollTo("pointer", anchor: .trailing)
                                            }
                                        }
                                    }
                                }
                                .allowsHitTesting(false)
                                .onAppear {
                                    signUpData.trajectHeight = trajectHeight
                                    signUpData.currentStep = 1
                                    initialAnimation()
                                }
                            }
                        }
                        .onTapGesture {
                            hideKeyboard()
                        }
                    }
                    .environmentObject(signUpData)
                    .environmentObject(state)
                    .navigationBarBackButtonHidden()
                    .navigationBarHidden(true)
                    .opacity(1.0 - state.mainViewOpacity)
                
            }
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private func initialAnimation() {
        withAnimation {
            state.currentCursorStep = 1
            state.lineWidth = .infinity
        }
    }
    
    private func nextStep() {
        let fieldTypes: [SignUpField] = [.email, .password, .confirmPassword, .name]
        state.lineColor = .green
        state.placeholder = ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                state.lineWidth = 5
                state.lineColor = .green
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                state.currentCursorStep += 1
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                state.lineColor = .gray
                state.textFieldtext = ""
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            state.shouldScroll.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if state.currentCursorStep <= signUpData.numberOfSteps {
                withAnimation {
                    state.fieldType = fieldTypes[state.currentCursorStep - 1]
                    state.placeholder = updatePlaceholder()
                    state.lineWidth = .infinity
                }
            } else {
                signUpData.signUpSucces = true
                animateIntro()
            }
        }
    }
    
    private func previousStep() {
        let fieldTypes: [SignUpField] = [.email, .password, .confirmPassword, .name]
        state.placeholder = ""
        signUpData.error = ""
        
        withAnimation {
            if state.currentCursorStep != 4 {
                state.currentCursorStep -= 1
            } else {
                state.currentCursorStep -= 2
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                state.shouldScroll.toggle()
                state.textFieldtext = getUserData()
                state.fieldType = fieldTypes[state.currentCursorStep - 1]
            }
            state.placeholder = updatePlaceholder()
        }
    }
    
    private func getUserData() -> String {
        switch state.currentCursorStep {
        case 1:
            return signUpData.userData.email
        case 2:
            return signUpData.userData.password
        case 3:
            return signUpData.userData.confirmedPassword
        case 4:
            return signUpData.userData.name
        default:
            return ""
        }
    }
    
    private func animateIntro() {
        withAnimation {
            state.showSuccess = true
            state.showCheckMark = true
            state.shouldWelcome = true
            state.titleText = "Welcome \(signUpData.userData.name)"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                state.titleText = ""
                // center SignUpTraject
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(Animation.easeInOut(duration: 1.5)) {
                state.currentCursorStep = 0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            state.shouldScroll.toggle()
            state.showCheckMark = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            state.showMainView = true
            withAnimation {
                state.mainViewOpacity += 1.1
            }
        }
    }
    
    private func updatePlaceholder() -> String {
        switch state.fieldType {
        case .email:
            return "What's your email?"
        case .password:
            return "Add a password"
        case .confirmPassword:
            return "Confirm your password"
        case .name:
            return "What's your name?"
        }
    }
}

struct SignUpStep: View {
    @EnvironmentObject var signUpData: SignUpData
    @EnvironmentObject var state: AnimationState
    
    var onNext: () -> Void
    var onBack: () -> Void
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer(minLength: geo.size.height / 2 - 40)
                
                if !state.showSuccess {
                    CustomTextField()
                        .padding(.leading, 25)
                }
                
                Spacer()
                
                if let error = signUpData.error {
                    Text(error)
                        .font(.system(size: 22, design: .rounded))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 25)
                        .padding(.trailing, 40)
                    Spacer(minLength: geo.size.height / 3)
                }
                
                
                VStack {
                    NavigationLink(destination: LoginPage()) {
                        Text("or Sign In here.")
                    }

                    HStack {
                        if state.currentCursorStep > 1 {
                            Button {
                                onBack()
                            } label: {
                                Text("Back")
                                    .font(.system(size: 25))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(.red)
                                    .cornerRadius(15)
                            }
                        }

                        Button {
                            if let error = validateInput() {
                                signUpData.error = error
                            } else {
                                signUpData.addDataFor(field: state.fieldType, data: state.textFieldtext)
                                signUpData.error = nil
                                onNext()
                            }
                        } label: {
                            Text("Next stop")
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                                .padding()
                                .background(.green)
                                .cornerRadius(15)
                    }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private func validateInput() -> String? {
        switch state.fieldType {
        case .email :
            return state.textFieldtext.contains("@") ? nil : "Your email address seems invalid"
        case .password :
            let decimalCharacters = CharacterSet.decimalDigits
            let decimalRange = state.textFieldtext.rangeOfCharacter(from: decimalCharacters)
            if state.textFieldtext.count >= 6 && decimalRange != nil {
                return nil
            } else if state.textFieldtext.count >= 6 {
                return "Your password must contain at least 1 number"
            } else {
                return "Your password must be at least 6 characters long"
            }
        case .confirmPassword :
            if state.textFieldtext == signUpData.userData.password {
                return nil
            }
            return "Oops your password doesn't match!"
        case .name:
            return state.textFieldtext == "" ? "How should we call you?" : nil
        }
    }
}

struct CustomTextField: View {
    @EnvironmentObject var signUpData: SignUpData
    @EnvironmentObject var state: AnimationState
    
    var body: some View {
        inputField()
    }
    
    func inputField() -> some View {
        return AnyView(
            Group {
                if state.fieldType != .password && state.fieldType != .confirmPassword {
                    TextField("", text: $state.textFieldtext, onEditingChanged: { editing in
                        state.isEditing = editing
                    })
                    .textContentType(state.fieldType == .email ? .emailAddress : .name)
                } else {
                    SecureField("", text: $state.textFieldtext)
                        .onChange(of: state.textFieldtext) { newValue in
                            state.isEditing = !newValue.isEmpty
                        }
                }
            }
                .font(.system(size: 24))
                .foregroundColor(.white)
                .accentColor(.white)
                .textInputAutocapitalization(TextInputAutocapitalization.never)
                .autocorrectionDisabled()
                .placeholder(when: state.textFieldtext.isEmpty) {
                    Text(state.placeholder)
                        .foregroundColor(.white.opacity(0.5))
                        .font(.system(size: 30))
                }
        )
    }
}

func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        let signUpData: SignUpData = SignUpData(numberOfSteps: 4)
        CustomSignUp(signUpData: signUpData)
    }
}

