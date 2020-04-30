//
//  Forecast.swift
//  Weatherer
//
//  Created by HexaHack on 30.04.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import Foundation
//MARK: - Forecast
//[Forecasts].5[DayForecasts].8[TimeForecast]
struct Forecasts{
    var dayForecast: [DayForecast]
//    var city: City
    init(lists: [List]) {
        dayForecast = [DayForecast]()
        var day =  DayForecast()
        let today = Date()
        day.setDate(date: today)
        var dayNumber = day.getDateComponent(.day)
        
        for listitem in lists {
            let listDate = Date(timeIntervalSince1970: Double(listitem.dt))
            let itemDay = Calendar.current.dateComponents(in: TimeZone(abbreviation: "UTC")!, from: listDate).day
            if itemDay != dayNumber {
                dayForecast.append(day)
                day = DayForecast()
                day.setDate(date: listDate)
                dayNumber = day.getDateComponent(.day)
            }
            day.addTimeForecast(listItem: listitem)
        }
    }
}



class DayForecast: NSObject {
    //from list
    var dayTime: [TimeForecast] = [TimeForecast]()
    var date: Date = Date()
    
    func setDate(date: Date) {
        self.date = date
    }
    
    func setDate(dateUNIX: Int) {
        self.date = Date(timeIntervalSince1970: Double(dateUNIX))
    }
    
    func getDateComponent(_ component: Calendar.Component) -> Int{
        let number = Calendar.current.component(component, from: date)
        return number
    }
    
    func addTimeForecast(listItem: List){
        let timeForecast = TimeForecast(dt: Date(timeIntervalSince1970: Double(listItem.dt)),
                                        temp: listItem.main.temp,
                                        feelsLike: listItem.main.feelsLike,
                                        tempMin: listItem.main.tempMin,
                                        tempMax: listItem.main.tempMax,
                                        pressure: listItem.main.pressure,
                                        seaLevel: listItem.main.seaLevel,
                                        grndLevel: listItem.main.grndLevel,
                                        humidity: listItem.main.humidity,
                                        tempKf: listItem.main.tempKf,
                                        id: listItem.weather[0].id,
                                        main: listItem.weather[0].main,
                                        weatherDescription: listItem.weather[0].weatherDescription,
                                        icon: listItem.weather[0].icon,
                                        windSpeed: listItem.wind.speed,
                                        windDeg: listItem.wind.deg,
                                        dtTxt: listItem.dtTxt)
        dayTime.append(timeForecast)
    }
    
    
}

struct TimeForecast {
    var dt: Date
    var temp: Double
    var feelsLike: Double
    var tempMin: Double
    var tempMax: Double
    var pressure: Int
    var seaLevel: Int
    var grndLevel: Int
    var humidity: Int
    var tempKf: Double
    var id: Int
    var main: String
    var weatherDescription: String
    var icon: String
    var windSpeed: Double
    var windDeg: Int
    var dtTxt:String
    
}
