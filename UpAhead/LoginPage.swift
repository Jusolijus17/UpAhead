//
//  ConnectionPage.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-03.
//

import SwiftUI

struct LoginPage: View {
    // Variables pour stocker les données entrées par l'utilisateur
    @State private var username = ""
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
                    TextField("Nom d'utilisateur", text: $username)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)

                    SecureField("Mot de passe", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)

                    NavigationLink(
                        destination: MainView(timelineData: TimelineData(days: generateWeek(), currentDayIndex: 3)),
                        label: {
                            Text("Se connecter")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 220, height: 60)
                                .background(Color.blue)
                                .cornerRadius(15.0)
                        })
                }
                .offset(y: -75/2)

                Spacer()

            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Ajout d'une contrainte de taille maximale
        }
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
