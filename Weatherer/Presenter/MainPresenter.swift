//
//  MainPresenter.swift
//  Weatherer
//
//  Created by HexaHack on 30.04.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import Foundation

protocol MainViewProtocol: class {
        
    func succes()
    func failure(error: Error)
}
protocol MainViewPresenterProtocol: class {
    init(networkService:  NetworkServiceProtocol )
    var forecasts: Forecasts? {get set}
    func  getForecasts(_ view: MainViewProtocol)
}

class MainPresenter: MainViewPresenterProtocol {
    var forecasts: Forecasts?
    weak var view: MainViewProtocol?
    let networkService: NetworkServiceProtocol
    
    required init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getForecasts(_ view: MainViewProtocol) {
        self.view = view
        networkService.getForecast { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let forecasts):
                    self.forecasts = forecasts
                    self.view?.succes()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
}
