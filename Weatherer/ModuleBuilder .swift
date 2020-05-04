//
//  ModuleBuilder .swift
//  Weatherer
//
//  Created by HexaHack on 04.05.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import UIKit

protocol Builder {
    static func createMainModule() -> UIViewController
}

class ModuleBuilder: Builder {
    
    static func createMainModule() -> UIViewController {
        let view = MainViewController()
        let locationService = LocationService()
        let networkService = NetworkService(locationService: locationService)
        let presenter = MainPresenter(view: view, networkService: networkService)
        view.presenter = presenter
        return view
    }
    
    
}
