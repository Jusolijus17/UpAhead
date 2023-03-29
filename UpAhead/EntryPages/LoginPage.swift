//
//  ConnectionPage.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-03.
//

import SwiftUI
import FirebaseAuth

struct LoginPage: View {
    // Variables pour stocker les données entrées par l'utilisateur
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Affiche une image ou un logo pour l'application
                Image("road")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 75, height: 75)
                
                Text("UpAhead!")
                    .font(.title)
                    .fontWeight(.bold)

                Spacer()

                Group {
                    // Formulaire de connexion
                    TextField("Email address", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                    
                    Button {
                        connectUser()
                    } label: {
                        Text("Connect")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(15.0)
                    }
                }
                .offset(y: -75/2)
                
                Spacer()
                
                HStack {
                    
                    NavigationLink(
                        destination: MainView(timelineData: TimelineData(days: generateDummyWeek(), currentDayIndex: 3)),
                        label: {
                            Text("Skip for now")
                                .foregroundColor(.blue)
                        }
                    )
                    
                    Spacer()
                    
                    NavigationLink(
                        destination: CustomSignUp(signUpData: SignUpData(numberOfSteps: 4)),
                        label: {
                            Text("Create account")
                                .foregroundColor(.blue)
                        }
                    )

                    
                }

            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Ajout d'une contrainte de taille maximale
        }
        .navigationBarBackButtonHidden()
    }
    
    private func connectUser() {
        // Connect user here
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
