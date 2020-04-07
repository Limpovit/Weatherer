//
//  DayPickerView.swift
//  Weatherer
//
//  Created by HexaHack on 4/2/20.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import UIKit


protocol DayPickerViewDataSource {
    func dayPickerCount(_ dayPicker: DayPickerView) -> Int
    func dayPickerTitle(_ dayPicker: DayPickerView, indexPath: IndexPath) -> String
}

class DayPickerView: UIControl {
    public var dataSourse: DayPickerViewDataSource? {
        didSet {
        setupView()
            self.backgroundColor = .systemGreen
            
        }
        
    }
    
     
    private var buttons: [UIButton] = []
    private var stackView: UIStackView!
    
    public var onButtonPressed: Int = 0
    public var myVC: ViewController? = nil
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    func setupView() {
        let count = dataSourse?.dayPickerCount(self)
        
        for item in 0..<count! {
            let indexPath = IndexPath(row: item, section: 0)
            let title = dataSourse?.dayPickerTitle(self, indexPath: indexPath)
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.tag = item
            button.setTitleColor(UIColor.white, for: .normal)
            button.setTitleColor(UIColor.white, for: .selected)
            button.addTarget(self, action: #selector(selectedButton), for: .touchUpInside)
            buttons.append(button)
            self.addSubview(button)
            
        }
        
        buttons[0].isSelected = true
        
        stackView = UIStackView(arrangedSubviews: self.buttons)
        self.addSubview(stackView)
        stackView.backgroundColor = .systemPink
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
    }
    
    @objc func selectedButton(sender: UIButton) {
        for b in buttons {
            b.isSelected = false
        }
        
        let index = sender.tag
        let button = self.buttons[index]
        button.isSelected = true
        onButtonPressed = index
        myVC?.getImage(forecastIndex: onButtonPressed)
          }
    
        
    }

