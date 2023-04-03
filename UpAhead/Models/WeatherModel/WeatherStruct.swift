//
//  WeatherStruct.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-03-05.
//

import Foundation
import CoreLocation

struct WeatherForecast: Codable {
    let daily: [DailyForecast]
}

struct DailyForecast: Codable {
    let dt: TimeInterval
    let temp: Temperature
    let weather: [Weather]
}

struct Temperature: Codable {
    let day: Double
    let night: Double
    let min: Double
    let max: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
}

class WeatherModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var dailyForecasts: [DailyForecast]?
    
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        
    }
    
    func fetchWeatherForecast() {
        
        guard let coordinates = getCurrentLocation() else {
            print("Unable to get user's location")
            return
        }
        
        let apiKey = "e0f44ae45481628328c7145c3d1aef5d"
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(coordinates.lat)&lon=\(coordinates.lon)&exclude=current,minutely,hourly,alerts&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to fetch weather forecast: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let weatherForecast = try decoder.decode(WeatherForecast.self, from: data)
                
                DispatchQueue.main.async {
                    self.dailyForecasts = weatherForecast.daily
                }
            } catch {
                print("Failed to decode weather forecast: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func requestAuthorization() {
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation() -> (lat: Double, lon: Double)? {
        let locationManager = CLLocationManager()
        var currentLocation: CLLocation?
        var locationTuple: (lat: Double, lon: Double)?

        // Vérifie si l'utilisateur a autorisé l'accès à la position de l'appareil
        let manager = CLLocationManager()
        guard manager.authorizationStatus == .authorizedWhenInUse else {
            requestAuthorization()
            return nil
        }

        // Récupère la position actuelle de l'utilisateur
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        currentLocation = locationManager.location
        locationManager.stopUpdatingLocation()

        // Extrait la latitude et la longitude de la position actuelle
        if let location = currentLocation {
            locationTuple = (lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        }

        return locationTuple
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        fetchWeatherForecast()
        print("Called")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erreur lors de la récupération de la position de l'utilisateur : \(error.localizedDescription)")
    }
}

