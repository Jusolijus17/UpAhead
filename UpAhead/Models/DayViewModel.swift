//
//  DayViewModel.swift
//  UpAhead
//
//  Created by Justin Lefrançois on 2023-04-02.
//

import Foundation
import SwiftUI

extension DayView {
    @MainActor class ViewModel: ObservableObject {
        let index: Int
        let titleSide: Side
        @ObservedObject var weatherModel: WeatherModel
        
        // Weather
        @Published private(set) var symbolName: String = ""
        @Published private(set) var temperature: String = "-/- °C"
        
        init(index: Int, titleSide: Side, weatherModel: WeatherModel) {
            self.index = index
            self.titleSide = titleSide
            self.weatherModel = weatherModel
        }
        
        func updateWeather(forecasts: [DailyForecast]?) {
            guard let forecasts = forecasts?.reversed() else { return }
            self.symbolName = weatherSymbolMapping[forecasts[forecasts.index(forecasts.startIndex, offsetBy: index)].weather[0].description] ?? ""
            let minTemp = forecasts[forecasts.index(forecasts.startIndex, offsetBy: index)].temp.min
            let maxTemp = forecasts[forecasts.index(forecasts.startIndex, offsetBy: index)].temp.max
            self.temperature = "\(Int(maxTemp.rounded())) / \(Int(minTemp.rounded())) °C"
        }
    }
}
