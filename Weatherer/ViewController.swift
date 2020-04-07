//
//  ViewController.swift
//  Weatherer
//
//  Created by HexaHack on 4/2/20.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var dayPicker: DayPickerView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var cityName: UILabel!
    
    //MARK: - Variables
    
    var city: City? = nil
    var forecast: Forecasts? = nil
    
    var days: [String] = []
    
    var dataImage = UIImage()
    
    let locationManager = CLLocationManager()
    
    var currentLocation = (latitude: 0.0, longitude: 0.0)
    
    var weatherURL: String = ""
    
    override func viewDidLoad() {
        view.backgroundColor = .systemGreen
        super.viewDidLoad()
        
        
        
        temperatureLabel.textAlignment = .center
        spinner.startAnimating()
        self.spinner.hidesWhenStopped = true
        days = getWeekday()
        print(days)
        dayPicker.dataSourse = self
        dayPicker.myVC = self
        
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
            
        }
        
        
        
    }
    
    
}
//MARK: - Delegate functions

extension ViewController: DayPickerViewDataSource, CLLocationManagerDelegate {
    func dayPickerCount(_ dayPicker: DayPickerView) -> Int {
        return days.count
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {return}
        self.currentLocation.latitude = locValue.latitude
        self.currentLocation.latitude = locValue.longitude
        weatherURL = "https://api.openweathermap.org/data/2.5/forecast?lat=\(locValue.latitude)&lon=\(locValue.longitude)&appid=97fe442c7c0483c140a556eaee51f3a1&units=metric&lang=ua"
        getWeatherData(apiUrl:  weatherURL)
        print("\(locValue.latitude) \(locValue.longitude)")
    }
    
    func dayPickerTitle(_ dayPicker: DayPickerView, indexPath: IndexPath) -> String {
        return days[indexPath.row]
    }
    
    //MARK: - Functions
    
    func getWeekday() -> [String] {
        let today = Date()
        let gregorian = Calendar(identifier: .gregorian)
        let dateComponents = gregorian.dateComponents([.weekday], from: today)
        let todaysWeekday = dateComponents.weekday!
        var otherWeekdays: [Int] = []
        
        for i in 0...4	 {
            otherWeekdays.append((todaysWeekday - 1 + i) % 7 + 1)
        }
        
        let weekdayNames = ["Вс","Пн","Вт","Ср","Чт","Пт","Сб"]
        let otherWeekdayStrings = otherWeekdays.map({weekdayNames[$0 - 1]})
        
        return otherWeekdayStrings
    }
    
    func getWeatherData(apiUrl: String) {
        guard let url = URL(string: apiUrl) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {return}
            guard error == nil else {return}
            
            do {
                
                let weather = try JSONDecoder().decode( OpenWeather.self, from: data)
                self.forecast = Forecasts(lists: weather.list)
                self.city = weather.city
                self.getImage(forecastIndex: self.dayPicker.onButtonPressed)
                DispatchQueue.main.async {
                    
                    self.showData()
                }
                
            } catch let error {
                print(error)
            }
            
        }.resume()
    }
    
    func showData(){
        spinner.stopAnimating()
        
        guard let  temp = forecast?.dayForecast[0].dayTime[0].temp else {return}
        temperatureLabel.text = "\(Int(temp))℃"
        weatherDescriptionLabel.text = forecast?.dayForecast[0].dayTime[0].weatherDescription
        cityName.text = self.city?.name
        weatherImage.image = dataImage
        
    }
    public func getImage(forecastIndex: Int) {
        guard let iconPath = forecast?.dayForecast[0].dayTime[0].icon else {return}
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(iconPath)@2x.png") else {return}
        print(url)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            
            
            print("Download Finished")
            DispatchQueue.main.async() {
                self.showData()
                self.weatherImage.image = UIImage(data: data)
                
            }
        }.resume()
        
    }
    
}


