// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let openWeather = try? newJSONDecoder().decode(OpenWeather.self, from: jsonData)

import Foundation

// MARK: - OpenWeather
struct OpenWeather: Codable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: City
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let timezone, sunrise, sunset: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double
}

// MARK: - List
struct List: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let sys: Sys
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, sys
        case dtTxt = "dt_txt"
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let pod: String
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}


//MARK: - Forecast
//[Forecasts].5[DayForecasts].8[TimeForecast]
struct Forecasts{
    var dayForecast: [DayForecast]
    
    init(lists: [List]) {
              dayForecast = [DayForecast]()
        let forecastsForDay = 8
        for index in 0..<5 {
            var day = DayForecast()
            
            for index2 in 0..<forecastsForDay {
                day.addTimeForecast(listItem: lists[(index*forecastsForDay)+index2])
            }
            dayForecast.append(day)
        }
    }
}

struct DayForecast {
       //from list
       var dayTime: [TimeForecast]
       
       init() {
           dayTime = [TimeForecast]()
        }
    mutating func addTimeForecast(listItem: List){
    let timeForecast = TimeForecast(temp: listItem.main.temp,
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
                                windDeg: listItem.wind.deg)
        dayTime.append(timeForecast)
       }
   }

struct TimeForecast {
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
    
    
}



