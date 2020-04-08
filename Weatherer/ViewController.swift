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
    
    @IBOutlet weak var dayPicker: UIStackView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var timePicker: UIPickerView!
    //MARK: - Variables
    
    var city: City? = nil
    var forecast: Forecasts? = nil
    
    var days: [String] = []
    
    let locationManager = CLLocationManager()
    
    var currentLocation = (latitude: 0.0, longitude: 0.0)
    
    var weatherURL: String = ""
    
    var dayIndex: Int = 0
    
    let dayTimes = ["00:00", "03:00", "06:00", "09:00", "12:00", "15:00", "18:00", "21:00"]
    var timeIndex = 0
    
    //  for stackView
    private var buttons: [UIButton] = []
    
    //MARK: - ViewDidVoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGreen
        
        temperatureLabel.textAlignment = .center
        spinner.startAnimating()
        self.spinner.hidesWhenStopped = true
        days = getWeekday()
        print(days)
        setUpStackView()
        view.addSubview(dayPicker)
        
        timePicker.delegate = self
        
        //Location loading
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
            
        }
        
        
        
    }
    //MARK: - Functions
    
    func setUpStackView() {
        
        for item in 0..<5 {
            let title = days[item]
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.tag = item
            button.setTitleColor(UIColor.white, for: .normal)
            button.setTitleColor(UIColor.white, for: .selected)
            button.addTarget(self, action: #selector(selectedButton), for: .touchUpInside)
            buttons.append(button)
            dayPicker.addArrangedSubview(button)
        }
        
        buttons[0].isSelected = true        
        dayPicker.spacing = 8
        dayPicker.axis = .horizontal
        dayPicker.distribution = .fillEqually
        dayPicker.alignment = .center
        
    }
    
    @objc func selectedButton(sender: UIButton) {
        for b in buttons {
            b.isSelected = false
        }
        let index = sender.tag
        let button = self.buttons[index]
        button.isSelected = true
        self.dayIndex = index
    }
    
    func getWeekday() -> [String] {
        let today = Date()
        let gregorian = Calendar(identifier: .gregorian)
        let dateComponents = gregorian.dateComponents([.weekday], from: today)
        let todaysWeekday = dateComponents.weekday!
        var otherWeekdays: [Int] = []
        
        for i in 0...4     {
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
                self.getImage(forecastIndex: self.dayIndex, timeIndex: self.timeIndex)
                
            } catch let error {
                print(error)
            }
            
        }.resume()
    }
    
    func showData(forecastIndex: Int, timeIndex: Int){
        spinner.stopAnimating()
        
        guard let  temp = forecast?.dayForecast[forecastIndex].dayTime[timeIndex].temp else {return}
        print("\(dayIndex), \(timeIndex)")
        temperatureLabel.text = "\(Int(temp))℃"
        weatherDescriptionLabel.text = forecast?.dayForecast[dayIndex].dayTime[timeIndex].weatherDescription
        cityName.text = self.city?.name
        
        
    }
    
    public func getImage(forecastIndex: Int, timeIndex: Int) {
        guard let iconPath = forecast?.dayForecast[forecastIndex].dayTime[timeIndex].icon else {return}
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(iconPath)@2x.png") else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.showData(forecastIndex: forecastIndex, timeIndex: timeIndex)
                self.weatherImage.image = UIImage(data: data)
                
            }
        }.resume()
        
    }
    
    
}
//MARK: - Delegate functions

extension ViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {return}
        self.currentLocation.latitude = locValue.latitude
        self.currentLocation.latitude = locValue.longitude
        weatherURL = "https://api.openweathermap.org/data/2.5/forecast?lat=\(locValue.latitude)&lon=\(locValue.longitude)&appid=97fe442c7c0483c140a556eaee51f3a1&units=metric&lang=ua"
        getWeatherData(apiUrl:  weatherURL)
        print("\(locValue.latitude) \(locValue.longitude)")
    }
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dayTimes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        dayTimes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        timeIndex = row
        showData(forecastIndex: self.dayIndex, timeIndex: timeIndex)
    }
    
    
}


