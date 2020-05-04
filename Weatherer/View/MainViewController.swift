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
    
    
    var presenter: MainViewPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

   

}
//MARK: - Extensions

extension MainViewController: MainViewProtocol {
    func succes() {
        <#code#>
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
    
}
