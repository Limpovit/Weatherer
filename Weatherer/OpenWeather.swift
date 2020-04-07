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
        
        for index in 1...4{
            var listItems: [List] = [List]()
            for index2 in 1...7 {
                listItems.append(lists[(index*index2)-1])
            }
            dayForecast.append(DayForecast(listItems: listItems))
        }
        
    }
    
    
    struct DayForecast {
        //from list
        var dayTime: [TimeForecast]
        
        init(listItems: [List]) {
            dayTime = [TimeForecast]()
            
            for item in listItems {
            dayTime.append(TimeForecast(temp: item.main.temp,
                                        feelsLike: item.main.feelsLike,
                                        tempMin: item.main.tempMin,
                                        tempMax: item.main.tempMax,
                                        pressure: item.main.pressure,
                                        seaLevel: item.main.seaLevel,
                                        grndLevel: item.main.grndLevel,
                                        humidity: item.main.humidity,
                                        tempKf: item.main.tempKf,
                                        id: item.weather[0].id,
                                        main: item.weather[0].main,
                                        weatherDescription: item.weather[0].weatherDescription,
                                        icon: item.weather[0].icon,
                                        windSpeed: item.wind.speed,
                                        windDeg: item.wind.deg))
            }
        }
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



