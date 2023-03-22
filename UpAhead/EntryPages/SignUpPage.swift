//
//  CreateAccountPage.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-20.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var error: String?
    @State private var isLinkActive: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Create an Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                
                VStack(spacing: 20) {
                    TextField("Email Address", text: $email)
                        .font(.headline)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    
                    SecureField("Password", text: $password)
                        .font(.headline)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    
                    SecureField("Confirm Password", text: $confirmPassword)
                        .font(.headline)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                }
                .padding(.horizontal, 50)
                
                Button(action: signUp) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 50)
                .disabled(isLoading)
                
                if let errorMessage = error {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                Spacer()
            }
            .padding(.top, 100)
            .onTapGesture {
                hideKeyboard()
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    private func signUp() {
        isLoading = true
        error = nil
        
        if password != confirmPassword {
            error = "Password does not match"
            isLoading = false
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                if let error = error {
                    self.error = error.localizedDescription
                    isLoading = false
                } else {
                    isLinkActive = true
                }
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct CustomSignUp: View {
    @State private var email: String = ""
    @State private var currentStep: Int = 1
    @State private var numberOfStep: Int = 4
    var body: some View {
        ZStack {
            Color(hex: "394A59")
                .ignoresSafeArea()
            HStack {
                SignUpStep(email: $email, onNext: {
                    withAnimation {
                        currentStep += 1
                    }
                })
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        SignUpTraject(currentStep: $currentStep, numberOfSteps: $numberOfStep)
                            .frame(width: 55, height: UIScreen.main.bounds.height * 2.0)
                            .ignoresSafeArea()
                    }
                    .scrollDisabled(true)
                    .onAppear {
                        proxy.scrollTo("pointer")
                    }
                    .onChange(of: currentStep) { _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation {
                                proxy.scrollTo("pointer", anchor: .center)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct SignUpStep: View {
    @Binding var email: String
    
    var onNext: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            CustomTextField(text: $email)
                .padding()
            
            Spacer()
            
            Button {
                onNext()
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

struct CustomTextField: View {
    @Binding var text: String
    @State var isEditing: Bool = false
    
    var underlineColor: Color {
        var color: Color = .gray
        if isEditing && !text.contains("@") {
            color = .red
        } else if isEditing && text.contains("@") {
            color = .green
        }
        return color
    }
    
    var body: some View {
        VStack(spacing: 10) {
            TextField("", text: $text, onEditingChanged: { editing in
                isEditing = editing
            })
                .font(.system(size: 24))
                .foregroundColor(.white)
                .accentColor(.white)
                .placeholder(when: text.isEmpty) {
                    Text("Your email")
                        .foregroundColor(.white.opacity(0.5))
                        .font(.system(size: 30))
                }
            
            Rectangle()
                .frame(height: 1.5)
                .foregroundColor(underlineColor)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        CustomSignUp()
    }
}

