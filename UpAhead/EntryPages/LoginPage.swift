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
                    .foregroundColor(.white)

                Spacer()

                Group {
                    // Formulaire de connexion
                    TextField("", text: $email)
                        .placeholder(when: email.isEmpty) {
                            Text("Email address")
                                .foregroundColor(.white.opacity(0.5))
                                .font(.system(size: 20))
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                        

                    SecureField("", text: $password)
                        .placeholder(when: password.isEmpty) {
                            Text("Password")
                                .foregroundColor(.white.opacity(0.5))
                                .font(.system(size: 20))
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
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
                            HStack(spacing: 2) {
                                Image(systemName: "clock")
                                    .foregroundColor(.orange)
                                
                                Text("Skip for now")
                                    .foregroundColor(.orange)
                                    .fontWeight(.semibold)
                            }
                        }
                    )
                    
                    Spacer()
                    
                    NavigationLink(
                        destination: CustomSignUp(signUpData: SignUpData(numberOfSteps: 4)),
                        label: {
                            
                            HStack(spacing: 2) {
                                Text("Create account")
                                    .foregroundColor(.orange)
                                    .fontWeight(.semibold)
                                
                                Image(systemName: "chevron.right.circle.fill")
                                    .foregroundColor(.orange)
                            }
                        }
                    )

                    
                }

            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Ajout d'une contrainte de taille maximale
            .background(Color(hex: "394A59"))
        }
        .navigationBarBackButtonHidden()
        .animation(Animation.spring())
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
