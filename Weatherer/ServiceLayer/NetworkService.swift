//
//  File.swift
//  Weatherer
//
//  Created by HexaHack on 30.04.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    func getForecast(completion: @escaping (Result<[DayForecast]?, Error>) -> Void)
    
}

class NetworkService: NetworkServiceProtocol {

    
   
    
    func getForecast(completion: @escaping (Result<[DayForecast]?, Error>) -> Void) {
        var location = (latitude: 0.0, longitude: 0.0)
        var weatherURL = "https://api.openweathermap.org/data/2.5/forecast?lat=\(location.latitude)&lon=\(location.longitude)&appid=97fe442c7c0483c140a556eaee51f3a1&units=metric&lang=ua"
        guard let url = URL(string: weatherURL) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                
                let obj = try JSONDecoder().decode( OpenWeather.self, from: data!)
                 var forecast = Forecasts(lists: obj.list)
                 var city = obj.city
//                sunTime = self.getSunsetAndSunrise(obj)
//                getImage(forecastIndex: self.dayIndex, timeIndex: self.timeIndex)
                
            } catch let error {
                print(error)
            }
            
        }.resume()
    }
    
    }
 
