//
//  WatherDataModel.swift
//  SimplyWeatherApp
//
//  Created by Nadzieja on 08/07/2019.
//  Copyright © 2019 Nadzieja Siwucha. All rights reserved.
//

import Foundation
import UIKit

class WeatherDataModel {
    

        var temperature: Int = 0
        var weatherID: Int = 0
        var city: String = ""
        var weatherIconName: String = ""
        var wind: Int = 0
        var humidity: Int = 0

    
        func updateWeatherIcon(weatherID: Int) -> String {
    
            switch (weatherID) {
                
                case 200...232 :
                    return "tstorm1"
    
                case 300...321 :
                    return "light_rain"
    
                case 500...531:
                    return "shower3"
    
                case 600...622 :
                    return "snow4"
    
                case 701...771 :
                    return "fog"
    
                case 772...781:
                    return "tstorm3"
    
                case 800 :
                    return "sunny"
    
                case 801...804 :
                    return "cloudy2"
    
                default :
                    return "dunno"
                }
        }
}

