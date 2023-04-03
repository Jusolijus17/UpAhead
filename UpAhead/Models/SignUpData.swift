//
//  SignUpData.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-22.
//

import SwiftUI

enum SignUpField {
    case email
    case password
    case confirmPassword
    case name
}

struct UserData {
    var email: String = ""
    var password: String = ""
    var confirmedPassword: String = ""
    var name: String = ""
}

class SignUpData: ObservableObject {
    // User data
    @Published var userData: UserData = UserData()
    
    // Other info
    @Published var isEditing: Bool = false
    @Published var currentStep: Int = 0
    @Published var numberOfSteps: Int
    @Published var trajectHeight: CGFloat = 0
    @Published var error: String?
    @Published var stepCompleted: Int = 0
    @Published var signUpSucces: Bool = false
    
    init(numberOfSteps: Int) {
        self.numberOfSteps = numberOfSteps
    }
    
    func addDataFor(field: SignUpField, data: String) {
        switch field {
        case .email :
            stepCompleted = 1
            userData.email = data
            break
        case .password :
            stepCompleted = 2
            userData.password = data
            break
        case .confirmPassword :
            stepCompleted = 3
            userData.confirmedPassword = data
            break
        case .name :
            stepCompleted = 4
            userData.name = data
            break
        }
    }
}
