//
//  SwinjectStoryboard+Extension.swift
//  Weatherer
//
//  Created by HexaHack on 06.05.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import UIKit
import SwinjectStoryboard
import Swinject


extension SwinjectStoryboard {
    @objc class func setup() {

        defaultContainer.storyboardInitCompleted(MainViewController.self) { r, c in
            c.presenter = r.resolve(MainViewPresenterProtocol.self)
        }

        defaultContainer.register(LocationServiceProtocol.self) { _ in LocationService() }
        defaultContainer.register(NetworkServiceProtocol.self) { r in
            NetworkService(locationService: r.resolve(LocationServiceProtocol.self)!) }
        defaultContainer.register(MainViewController.self) { _ in MainViewController() }
        defaultContainer.register(MainViewPresenterProtocol.self) { r in
            MainPresenter(networkService: r.resolve(NetworkServiceProtocol.self)!)

        }
    }
}

