//
//  ChangeCityViewController.swift
//  SimplyWeatherApp
//
//  Created by Nadzieja on 08/07/2019.
//  Copyright © 2019 Nadzieja Siwucha. All rights reserved.
//

import UIKit


protocol ChangeCityDelegate {
    func userEnteredANewCityName(city: String)
}



class ChangeCityViewController: UIViewController {
    
    
    var delegate : ChangeCityDelegate?
    
    
    @IBOutlet weak var changeCityTextField: UITextField!
    
    @IBAction func getWeatherPressed(_ sender: UIButton) {
        
        let cityName = changeCityTextField.text!
        delegate?.userEnteredANewCityName(city: cityName)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
