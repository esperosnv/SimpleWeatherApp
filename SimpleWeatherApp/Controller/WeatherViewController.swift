//
//  ViewController.swift
//  SimplyWeatherApp
//
//  Created by Nadzieja on 08/07/2019.
//  Copyright © 2019 Nadzieja Siwucha. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {

    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "7ec51160bf4fc83903bf3d9f1897b373"
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windTextLabel: UILabel!
    @IBOutlet weak var humidityTextLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var changeCityButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNotVisible()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    
    //MARK: - JSON Parsing
    
    func getWeatherData(url: String, parameters: [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            
            if response.result.isSuccess {
                print("Data Received")
                let weatherJSON : JSON = JSON(response.result.value!)
                print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
                
            } else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
                }
            }
        }
    
    
    //MARK: - UI Updates
    
    func updateWeatherData(json : JSON) {
        
        if let temperatureJSON = json["main"]["temp"].double  {
            
            weatherDataModel.temperature = Int(temperatureJSON - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.weatherID = json["weather"][0]["id"].intValue
            weatherDataModel.wind = json["wind"]["speed"].intValue
            weatherDataModel.humidity = json["main"]["humidity"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(weatherID: weatherDataModel.weatherID)
            
            updateUI()
                
        } else {

            cityLabel.text = "Weather Unavailable"
                
            makeNotVisible()
            cityLabel.alpha = 1
            changeCityButton.alpha = 1
        }
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func updateUI() {
        cityLabel.text = weatherDataModel.city
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        windLabel.text = "\(weatherDataModel.wind) m/s"
        humidityLabel.text = "\(weatherDataModel.humidity) %"
        temperatureLabel.text = "\(weatherDataModel.temperature)˚C"
        
        makeVisible()
    }
    
    func makeVisible() {

        cityLabel.alpha = 1
        weatherIcon.alpha = 1
        windLabel.alpha = 1
        humidityLabel.alpha = 1
        temperatureLabel.alpha = 1
        windTextLabel.alpha = 1
        humidityTextLabel.alpha = 1
        changeCityButton.alpha = 1
    }
    
    func makeNotVisible() {
        
        cityLabel.alpha = 0
        weatherIcon.alpha = 0
        windLabel.alpha = 0
        humidityLabel.alpha = 0
        temperatureLabel.alpha = 0
        windTextLabel.alpha = 0
        humidityTextLabel.alpha = 0
        changeCityButton.alpha = 0
        
        activityIndicator.startAnimating()
    }
    
    
    //MARK: - Location Manager Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            print("\(latitude), \(longitude)")
            let param: [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            getWeatherData(url: WEATHER_URL, parameters: param)
        }
    }
    

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
            print(error)
            cityLabel.text = "Location Unavailable"
    }
    
    
    
    //MARK: - Change City Delegate methods
    
    func userEnteredANewCityName(city: String) {
        
        let getParameters : [String : String] = ["q" : city, "appid" : APP_ID]
        
        makeNotVisible()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        getWeatherData(url: WEATHER_URL, parameters: getParameters)
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeCityName" {
            
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        }
        
    }
    


}

