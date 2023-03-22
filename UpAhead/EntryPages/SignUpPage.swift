//
//  CreateAccountPage.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-20.
//

import SwiftUI
import FirebaseAuth

//struct SignUpView: View {
//    @State private var email = ""
//    @State private var password = ""
//    @State private var confirmPassword = ""
//    @State private var isLoading = false
//    @State private var error: String?
//    @State private var isLinkActive: Bool = false
//    @Environment(\.presentationMode) var presentationMode
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 30) {
//                Text("Create an Account")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .foregroundColor(.blue)
//
//                Image(systemName: "checkmark.circle.fill")
//                    .resizable()
//                    .frame(width: 100, height: 100)
//                    .foregroundColor(.blue)
//
//                VStack(spacing: 20) {
//                    TextField("Email Address", text: $email)
//                        .font(.headline)
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(10)
//                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
//
//                    SecureField("Password", text: $password)
//                        .font(.headline)
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(10)
//                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
//
//                    SecureField("Confirm Password", text: $confirmPassword)
//                        .font(.headline)
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(10)
//                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
//                }
//                .padding(.horizontal, 50)
//
//                Button(action: signUp) {
//                    if isLoading {
//                        ProgressView()
//                    } else {
//                        Text("Sign Up")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.blue)
//                            .cornerRadius(10)
//                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
//                    }
//                }
//                .padding(.horizontal, 50)
//                .disabled(isLoading)
//
//                if let errorMessage = error {
//                    Text(errorMessage)
//                        .foregroundColor(.red)
//                }
//
//                Spacer()
//            }
//            .padding(.top, 100)
//            .onTapGesture {
//                hideKeyboard()
//            }
//        }
//        .navigationBarHidden(true)
//        .navigationBarBackButtonHidden(true)
//    }
//
//    private func signUp() {
//        isLoading = true
//        error = nil
//
//        if password != confirmPassword {
//            error = "Password does not match"
//            isLoading = false
//        } else {
//            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//
//                if let error = error {
//                    self.error = error.localizedDescription
//                    isLoading = false
//                } else {
//                    isLinkActive = true
//                }
//            }
//        }
//    }
//
//    private func hideKeyboard() {
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
//}

struct CustomSignUp: View {
    @StateObject var signUpData: SignUpData
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                let trajectHeight: CGFloat = geo.size.height * CGFloat(signUpData.numberOfSteps)
                ZStack {
                    Color(hex: "394A59")
                        .ignoresSafeArea()
                    
                    VStack {
                        Text("Create an account")
                            .font(.system(size: 35, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    ScrollViewReader { proxy in
                        ScrollView(showsIndicators: false) {
                            SignUpTraject()
                                .frame(height: geo.size.height * CGFloat(signUpData.numberOfSteps))
                                .ignoresSafeArea()
                        }
                        .scrollDisabled(true)
                        .onAppear {
                            proxy.scrollTo("pointer", anchor: .trailing)
                        }
                        .onChange(of: signUpData.currentStep) { _ in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation {
                                    proxy.scrollTo("pointer", anchor: .trailing)
                                }
                            }
                        }
                    }
                    
                    // Email
                    SignUpStep(onNext: {
                        if signUpData.currentStep <= signUpData.numberOfSteps + 1 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation {
                                    signUpData.currentStep += 1
                                }
                            }
                        }
                    })
                }
                .onAppear {
                    signUpData.trajectHeight = trajectHeight
                }
                .onTapGesture {
                    hideKeyboard()
                }
            }
            .environmentObject(signUpData)
        }
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SignUpStep: View {
    @State var text: String = ""
    @EnvironmentObject var signUpData: SignUpData
    @State var currentField: SignUpField = .email
    @State var currentFieldIndex: Int = 0
    
    var onNext: () -> Void
    
    var body: some View {
        let fields: [SignUpField] = [.email, .password, .confirmPassword, .name]
        
        GeometryReader { geo in
            VStack {
                Spacer(minLength: geo.size.height / 2 - 40)
                
                CustomTextField(text: $text, fieldType: $currentField)
                    .padding(.leading, 25)
                
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

                Button {
                    if let error = validateInput(field: currentField) {
                        signUpData.error = error
                    } else {
                        signUpData.addDataFor(field: currentField, data: text)
                        currentFieldIndex += 1
                        if currentFieldIndex < fields.count {
                            currentField = fields[currentFieldIndex]
                        }
                        withAnimation {
                            signUpData.error = nil
                            text = ""
                        }
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
    
    private func validateInput(field: SignUpField) -> String? {
        switch field {
        case .email :
            return text.contains("@") ? nil : "Your email address seems invalid"
        case .password :
            let decimalCharacters = CharacterSet.decimalDigits
            let decimalRange = text.rangeOfCharacter(from: decimalCharacters)
            if text.count >= 6 && decimalRange != nil {
                return nil
            } else if text.count >= 6 {
                return "Your password must contain at least 1 number"
            } else {
                return "Your password must be at least 6 characters long"
            }
        case .confirmPassword :
            if text == signUpData.userData.password {
                return nil
            }
            return "Oops your password doesn't match!"
        case .name:
            return text == "" ? "How should we call you?" : nil
        }
    }
}


struct CustomTextField: View {
    @Binding var text: String
    @Binding var fieldType: SignUpField
    @EnvironmentObject var signUpData: SignUpData
    
    @State var placeholder: String = ""
    
    var body: some View {
        inputField()
            .onChange(of: fieldType) { _ in
                placeholder = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        updatePlaceholder()
                    }
                }
            }
            .onAppear {
                updatePlaceholder()
            }
    }
    
    func inputField() -> some View {
        return AnyView(
            Group {
                if fieldType != .password && fieldType != .confirmPassword {
                    TextField("", text: $text, onEditingChanged: { editing in
                        signUpData.isEditing = editing
                    })
                } else {
                    SecureField("", text: $text)
                        .onChange(of: text) { newValue in
                            signUpData.isEditing = !newValue.isEmpty
                        }
                }
            }
            .font(.system(size: 24))
            .foregroundColor(.white)
            .accentColor(.white)
            .textInputAutocapitalization(TextInputAutocapitalization.never)
            .autocorrectionDisabled()
            .placeholder(when: text.isEmpty) {
                Text(placeholder)
                    .foregroundColor(.white.opacity(0.5))
                    .font(.system(size: 30))
            }
        )
    }
    
    private func updatePlaceholder() {
        switch fieldType {
        case .email:
            placeholder = "What's your email?"
        case .password:
            placeholder = "Add a password"
        case .confirmPassword:
            placeholder = "Confirm your password"
        case .name:
            placeholder = "What's your name?"
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        let signUpData: SignUpData = SignUpData(numberOfSteps: 4)
        CustomSignUp(signUpData: signUpData)
    }
}

