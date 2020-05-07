//
//  MainViewController.swift
//  Weatherer
//
//  Created by HexaHack on 04.05.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
//MARK: - IBOutlets
    @IBOutlet weak var gradientBackground: UIView?
     
    @IBOutlet weak var dayPicker: UIStackView?
    
    @IBOutlet weak var temperatureLabel: UILabel?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView?
    
    @IBOutlet weak var weatherDescriptionLabel: UILabel?
    
    @IBOutlet weak var weatherImage: UIImageView?
    @IBOutlet weak var sunriseLabel: UILabel?
    @IBOutlet weak var sunsetLabel: UILabel?
    
    @IBOutlet weak var cityLabel: UILabel?
    
    @IBOutlet weak var timePicker: UIPickerView?
    
   var presenter: MainViewPresenterProtocol!

    

    override func viewDidLoad() {
        super.viewDidLoad()
   
        presenter.getForecasts(self)
       
        
       
    }
    

   

}
//MARK: - Extensions

extension MainViewController: MainViewProtocol {
    
    func succes() {
        cityLabel?.text = presenter.forecasts?.city.name
       
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
        print("gfgd")
    }
    
    
}
