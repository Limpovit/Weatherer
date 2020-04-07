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
    dayForecast = [DayForecast()]
            var dayTimeFull: [TimeForecast] = []
         for list in lists{
                
                let timeForecast = TimeForecast(temp: list.main.temp,
                                                feelsLike: list.main.feelsLike,
                                                tempMin: list.main.tempMin,
                                                tempMax: list.main.tempMax,
                                                pressure: list.main.pressure,
                                                seaLevel: list.main.seaLevel,
                                                grndLevel: list.main.grndLevel,
                                                humidity: list.main.humidity,
                                                tempKf: list.main.tempKf,
                                                id: list.weather[0].id,
                                                main: list.weather[0].main,
                                                weatherDescription: list.weather[0].weatherDescription,
                                                icon: list.weather[0].icon,
                                                windSpeed: list.wind.speed,
                                                windDeg: list.wind.deg)
                dayTimeFull.append(timeForecast)
            }
    for index in 1...5{
        dayForecast.append(DayForecast())
        for index2 in 1...8 {
            dayForecast[index-1].dayTime.append(dayTimeFull[(index*index2)-1])
        }
        }

    }
    
    
    struct DayForecast {
        //from list
        var dayTime = [TimeForecast()]
        
          
}
struct TimeForecast {
    var temp = 0.0
    var feelsLike = 0.0
    var tempMin = 0.0
    var tempMax = 0.0
    var pressure = 0
    var seaLevel = 0
    var grndLevel  = 0
    var humidity  = 0
    var tempKf  = 0.0
    //from list.weather®
    var id  = 0
    var main = ""
    var weatherDescription = ""
    var icon = ""
    var windSpeed = 0.0
    var windDeg = 0
    
    
}
}


