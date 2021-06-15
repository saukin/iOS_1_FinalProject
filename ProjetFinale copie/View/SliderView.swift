//
//  SliderView.swift
//  ProjetFinale
//
//  Created by Siarhei Saukin (Étudiant) on 2021-06-09.
//  Copyright © 2021 Siarhei Saukin (Étudiant). All rights reserved.
//

import UIKit

class SliderView: UIView {
    
    @IBOutlet var toggleButton: UIButton!
    @IBOutlet var slider: UISlider!
    
    
    enum SliderStyle {
        case active, muted
    }
    
    private var style: SliderStyle = .active {
        didSet {
            switch style {
            case .active:
                self.alpha = 1
                slider.isUserInteractionEnabled = true
                self.toggleButton.tintColor = #colorLiteral(red: 0.9592687488, green: 0.7051939368, blue: 0.2017324567, alpha: 1)
            case .muted:
                self.alpha = 0.5
                slider.isUserInteractionEnabled = false
                self.toggleButton.tintColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            }
        }
    }
    
    func toggleSlider() {
        switch self.style {
        case .active:
            self.style = .muted
        case .muted:
            self.style = .active
        }
    }
}
