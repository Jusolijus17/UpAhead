//
//  Mappings.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-31.
//

import Foundation

let weatherSymbolMapping: [String: String] = [
    "thunderstorm with light rain": "cloud.bolt.rain.fill",
    "thunderstorm with rain": "cloud.bolt.rain.fill",
    "thunderstorm with heavy rain": "cloud.bolt.rain.fill",
    "light thunderstorm": "cloud.bolt.rain.fill",
    "thunderstorm": "cloud.bolt.rain.fill",
    "heavy thunderstorm": "cloud.bolt.rain.fill",
    "ragged thunderstorm": "cloud.bolt.rain.fill",
    "thunderstorm with light drizzle": "cloud.bolt.rain.fill",
    "thunderstorm with drizzle": "cloud.bolt.rain.fill",
    "thunderstorm with heavy drizzle": "cloud.bolt.rain.fill",
    "light intensity drizzle": "cloud.drizzle.fill",
    "drizzle": "cloud.drizzle.fill",
    "heavy intensity drizzle": "cloud.drizzle.fill",
    "light intensity drizzle rain": "cloud.drizzle.fill",
    "drizzle rain": "cloud.drizzle.fill",
    "heavy intensity drizzle rain": "cloud.drizzle.fill",
    "shower rain and drizzle": "cloud.drizzle.fill",
    "heavy shower rain and drizzle": "cloud.drizzle.fill",
    "shower drizzle": "cloud.drizzle.fill",
    "light rain": "cloud.rain.fill",
    "moderate rain": "cloud.rain.fill",
    "heavy intensity rain": "cloud.rain.fill",
    "very heavy rain": "cloud.rain.fill",
    "extreme rain": "cloud.rain.fill",
    "freezing rain": "cloud.hail.fill",
    "light intensity shower rain": "cloud.rain.fill",
    "shower rain": "cloud.rain.fill",
    "heavy intensity shower rain": "cloud.rain.fill",
    "ragged shower rain": "cloud.rain.fill",
    "light snow": "cloud.snow.fill",
    "snow": "cloud.snow.fill",
    "heavy snow": "cloud.snow.fill",
    "sleet": "cloud.sleet.fill",
    "shower sleet": "cloud.sleet.fill",
    "light rain and snow": "cloud.sleet.fill",
    "rain and snow": "cloud.sleet.fill",
    "light shower snow": "cloud.snow.fill",
    "shower snow": "cloud.snow.fill",
    "heavy shower snow": "cloud.snow.fill",
    "mist": "cloud.fog.fill",
    "smoke": "smoke.fill",
    "haze": "sun.haze.fill",
    "sand, dust whirls": "sun.dust.fill",
    "fog": "cloud.fog.fill",
    "sand": "sun.dust.fill",
    "dust": "sun.dust.fill",
    "volcanic ash": "smoke.fill",
    "squalls": "wind",
    "tornado": "tornado",
    "clear sky": "sun.max.fill",
    "few clouds": "cloud.sun.fill",
    "scattered clouds": "cloud.fill",
    "broken clouds": "smoke.fill",
    "overcast clouds": "cloud.fill"
]

enum WeatherType {
    case sun
    case cloud
    case rain
    case thunderstorm
    case snow
    case mist
    case other
}

let weatherTypeMapping: [String: WeatherType] = [
    "thunderstorm with light rain": .thunderstorm,
    "thunderstorm with rain": .thunderstorm,
    "thunderstorm with heavy rain": .thunderstorm,
    "light thunderstorm": .thunderstorm,
    "thunderstorm": .thunderstorm,
    "heavy thunderstorm": .thunderstorm,
    "ragged thunderstorm": .thunderstorm,
    "thunderstorm with light drizzle": .thunderstorm,
    "thunderstorm with drizzle": .thunderstorm,
    "thunderstorm with heavy drizzle": .thunderstorm,
    "light intensity drizzle": .rain,
    "drizzle": .rain,
    "heavy intensity drizzle": .rain,
    "light intensity drizzle rain": .rain,
    "drizzle rain": .rain,
    "heavy intensity drizzle rain": .rain,
    "shower rain and drizzle": .rain,
    "heavy shower rain and drizzle": .rain,
    "shower drizzle": .rain,
    "light rain": .rain,
    "moderate rain": .rain,
    "heavy intensity rain": .rain,
    "very heavy rain": .rain,
    "extreme rain": .rain,
    "freezing rain": .other,
    "light intensity shower rain": .rain,
    "shower rain": .rain,
    "heavy intensity shower rain": .rain,
    "ragged shower rain": .rain,
    "light snow": .snow,
    "snow": .snow,
    "heavy snow": .snow,
    "sleet": .rain,
    "shower sleet": .rain,
    "light rain and snow": .rain,
    "rain and snow": .rain,
    "light shower snow": .snow,
    "shower snow": .snow,
    "heavy shower snow": .snow,
    "mist": .mist,
    "smoke": .other,
    "haze": .other,
    "sand, dust whirls": .other,
    "fog": .mist,
    "sand": .other,
    "dust": .other,
    "volcanic ash": .other,
    "squalls": .other,
    "tornado": .other,
    "clear sky": .sun,
    "few clouds": .cloud,
    "scattered clouds": .cloud,
    "broken clouds": .other,
    "overcast clouds": .cloud
]
