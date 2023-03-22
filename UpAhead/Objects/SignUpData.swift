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
    @Published var currentStep: Int = 1
    @Published var numberOfSteps: Int
    @Published var trajectHeight: CGFloat = 0
    @Published var error: String?
    
    init(numberOfSteps: Int) {
        self.numberOfSteps = numberOfSteps
    }
    
    func addDataFor(field: SignUpField, data: String) {
        switch field {
        case .email :
            userData.email = data
            break
        case .password :
            userData.password = data
            break
        case .confirmPassword :
            userData.confirmedPassword = data
            break
        case .name :
            userData.name = data
            break
        }
    }
}
