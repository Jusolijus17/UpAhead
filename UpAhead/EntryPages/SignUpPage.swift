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
            VStack {
                Text("Créer un compte")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
                
                TextField("Adresse e-mail", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Mot de passe", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Confirmer le mot de passe", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                if let errorMessage = error {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
                
                Button(action: signUp) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Créer un compte")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }.disabled(isLoading)
                    .padding()
                
                NavigationLink(destination: MainView(timelineData: TimelineData(days: generateWeek(), currentDayIndex: 3)), isActive: $isLinkActive) {
                    EmptyView()
                }
                
            }
            .padding()
            .onTapGesture {
                hideKeyboard()
            }
        }
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

