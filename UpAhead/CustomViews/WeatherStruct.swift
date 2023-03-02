//
//  WeatherStruct.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-05.
//

import Foundation

let weatherSymbolMapping: [String: String] = [
    "clear sky": "sun.max.fill",
    "few clouds": "cloud.sun.fill",
    "scattered clouds": "cloud.fill",
    "broken clouds": "smoke.fill",
    "shower rain": "cloud.drizzle.fill",
    "rain": "cloud.rain.fill",
    "thunderstorm": "cloud.bolt.rain.fill",
    "snow": "cloud.snow.fill",
    "mist": "cloud.fog.fill"
]

struct WeatherData: Codable {
    let weather: [Weather]
    let main: Main
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
}

struct Main: Codable {
    let temp: Double
}

func fetchWeatherData(city: String, completion: @escaping (WeatherData?) -> ()) {
    let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=e0f44ae45481628328c7145c3d1aef5d&units=metric"
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }
        
        let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data)
        completion(weatherData)
    }.resume()
}

