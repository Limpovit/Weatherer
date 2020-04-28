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
    @IBOutlet weak var gradientBackground: UIView!
    
    @IBOutlet weak var dayPicker: UIStackView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var timePicker: UIPickerView!
    //MARK: - Variables
    
    var city: City? = nil
    var sunTime = (rise: "", set: "")
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
        
        self.setBackground(colors: [ UIColor.white.cgColor, UIColor.systemBlue.cgColor])
        
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
            self.locationManager.requestLocation()
            
        }
        
        
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: {
            _ in
            
            self.gradientBackground.layer.sublayers?.remove(at: 0)
            self.setBackground(colors: [ UIColor.white.cgColor, UIColor.systemBlue.cgColor])
            print("rotate")
        })
        
    }
    
    //MARK: - Functions
    
    func setBackground(colors: [CGColor]){
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = gradientBackground.bounds
        gradientLayer.colors = colors
        gradientBackground.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    func setUpStackView() {
        
        for item in 0..<5 {
            let title = days[item]
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.tag = item
            button.setTitleColor(UIColor.systemGray, for: .normal)
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
        self.timeIndex = 0
        getWeatherData(apiUrl:  weatherURL)
    }
    
    func getSunsetAndSunrise(_ data: OpenWeather ) -> (String, String) {
        
        
        
        let rise = Date(timeIntervalSince1970: Double(data.city.sunrise))
        let set =  Date(timeIntervalSince1970: Double(data.city.sunset))
        let riseHour = Calendar.current.component(.hour, from: rise)
        let setHour = Calendar.current.component(.hour, from: set)
        let riseMinute = Calendar.current.component(.minute, from: rise)
        let setMinute = Calendar.current.component(.minute, from: set)
        var zero  = (set: "", rise: "")
        if setMinute < 10 {
            zero.set = "0"
        }
        if riseMinute < 10 {
            zero.rise = "0"
        }
        
        return ("\(riseHour):\(zero.rise)\(riseMinute)", "\(setHour):\(zero.set)\(setMinute)")
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
                self.sunTime = self.getSunsetAndSunrise(weather)
                self.getImage(forecastIndex: self.dayIndex, timeIndex: self.timeIndex)
                
            } catch let error {
                print(error)
            }
            
        }.resume()
    }
    
    func showData(forecastIndex: Int, timeIndex: Int){
        spinner.stopAnimating()
        
        guard let  temp = forecast?.dayForecast[forecastIndex].dayTime[timeIndex].temp else {return}
        
        temperatureLabel.text = "\(Int(temp))"
        sunsetLabel.text = sunTime.set
        sunriseLabel.text = sunTime.rise
        weatherDescriptionLabel.text = forecast?.dayForecast[dayIndex].dayTime[timeIndex].weatherDescription
        cityName.text = self.city?.name
        
        
    }
    
    public func getImage(forecastIndex: Int, timeIndex: Int) {
        guard let iconPath = forecast?.dayForecast[forecastIndex].dayTime[timeIndex].icon else {return}
        guard let iconURL = URL(string: "https://openweathermap.org/img/wn/\(iconPath)@2x.png") else {return}
        var data = Data()
        do {
            data = try Data(contentsOf: iconURL)
        }
        catch {
            print("error image loading")
        }
        
        DispatchQueue.main.async() {
            print("\(self.dayIndex), \(self.timeIndex), \(self.forecast!.dayForecast[forecastIndex].dayTime[timeIndex].dtTxt)")
            self.timePicker.dataSource = self.forecast?.dayForecast[self.dayIndex]
            self.showData(forecastIndex: forecastIndex, timeIndex: timeIndex)
            self.weatherImage.image = UIImage(data: data)
            if iconPath.contains("n"){
                self.gradientBackground.layer.sublayers?.remove(at: 0)
                self.setBackground(colors: [UIColor.black.cgColor, UIColor.systemBlue.cgColor])
            } else {
                self.gradientBackground.layer.sublayers?.remove(at: 0)
                self.setBackground(colors: [ UIColor.white.cgColor, UIColor.systemBlue.cgColor])
            }
            
        }
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
    
    func  locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let time = forecast?.dayForecast[dayIndex].dayTime[row].dtTxt
        let startOfTime = time?.firstIndex(of: " ")
        
        return String(time![startOfTime!...])
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        timeIndex = row
        getWeatherData(apiUrl:  weatherURL)
    }       
}


