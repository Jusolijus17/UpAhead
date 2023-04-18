//
//  Enums.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-04-06.
//

import Foundation

enum WeekDay {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    var isWeekend: Bool {
        return self == .saturday || self == .sunday
    }
}

extension WeekDay {
    static func fromString(_ string: String) -> WeekDay? {
        switch string.lowercased() {
        case "monday":
            return .monday
        case "tuesday":
            return .tuesday
        case "wednesday":
            return .wednesday
        case "thursday":
            return .thursday
        case "friday":
            return .friday
        case "saturday":
            return .saturday
        case "sunday":
            return .sunday
        default:
            return nil
        }
    }
}


enum Side {
    case left
    case right
    
    var opposite: Side {
        return self == .left ? .right : .left
    }
}

enum WeatherType {
    case sun
    case cloud
    case rain
    case thunderstorm
    case snow
    case mist
    case other
}

enum SignUpField {
    case email
    case password
    case confirmPassword
    case name
}
