//
//  MainViewController.swift
//  PrettyWeather
//
//  Created by Arthur Ford on 12/10/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    var weatherForecastManager = WeatherForecastManager()
    
    var arrayOfLocations: [String] = []
    var arrayOfForecasts: [Forecast] = []
    var units = K.imperial
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var conditionsLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var conditionsImage: UIImageView!
    @IBOutlet weak var bottomConditionsImage: UIImageView!
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    var location: CLLocation?
    
    
    @IBOutlet weak var mainForecastTable: UITableView!
    
    var backgroundColor = UIColor(named: "00BAEE")
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        weatherForecastManager.delegate = self
        locationManager.delegate = self
        mainForecastTable.delegate = self
        mainForecastTable.dataSource = self
        registerTableViewCells()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        backgroundColor = UIColor(named: defaults.object(forKey: K.Defaults.color) as? String ?? K.Colors.color00BAEE) 
        view.backgroundColor = backgroundColor
        units = defaults.object(forKey: K.Defaults.units) as? String ?? K.imperial
        
    }
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: K.settingsSegueID, sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.settingsSegueID {
            let vc = segue.destination as! SettingsViewController
            vc.view.backgroundColor = self.view.backgroundColor
            vc.unitsSelected.selectedSegmentIndex = units == K.imperial ? 0 : 1
            
            switch self.view.backgroundColor {
            case UIColor(named: vc.button0039AF.title(for: .normal)!):
                vc.button0039AF.isSelected = true
            case UIColor(named: vc.button0086E4.title(for: .normal)!):
                vc.button0086E4.isSelected = true
            case UIColor(named: vc.button00AC01.title(for: .normal)!):
                vc.button00AC01.isSelected = true
            case UIColor(named: vc.button00AC1F.title(for: .normal)!):
                vc.button00AC1F.isSelected = true
            case UIColor(named: vc.button00BAEE.title(for: .normal)!):
                vc.button00BAEE.isSelected = true
            case UIColor(named: vc.button0B3E9E.title(for: .normal)!):
                vc.button0B3E9E.isSelected = true
            case UIColor(named: vc.button80ADDF.title(for: .normal)!):
                vc.button80ADDF.isSelected = true
             case UIColor(named: vc.buttonFF6B0A.title(for: .normal)!):
                vc.buttonFF6B0A.isSelected = true
            default:
                return
            }
            vc.delegate = self
        }
    }
    
    
    
}
//MARK: - Weather Manager Delegate

extension MainViewController: WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherObject) {
        DispatchQueue.main.async {
            self.tempLabel.text = self.units == K.imperial ? String(format: "%.0f", weather.main.temp) + "℉" : String(format: "%.0f", weather.main.temp) + "℃"
            self.cityLabel.text = weather.name
            self.conditionsImage.image = UIImage(systemName: weather.conditionName)
            self.bottomConditionsImage.image = UIImage(systemName: weather.conditionName)
            self.conditionsLabel.text = weather.weather[0].description
            let today = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM dd")
            self.datelabel.text = dateFormatter.string(from: today)
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - Weather Forecast Manager Delegate

extension MainViewController: WeatherForecastManagerDelegate {
    func didUpdateForecast(forecast: WeatherForecast) {
        
        arrayOfForecasts.removeAll()
        
        setupTable(forecast: forecast)
        
        DispatchQueue.main.async {
            self.mainForecastTable.reloadData()
        }
        
        
    }
    
    func didFailWithErrorForecast(error: Error) {
        print(error)
    }
    
    func setupTable(forecast: WeatherForecast) {
        var indicesForDays = [0,8,16,24,32,40]
        
        for (index, forecast) in forecast.list.enumerated() {
            if index == indicesForDays[0] {
                arrayOfForecasts.append(forecast)
                indicesForDays.remove(at: 0)
            }
        }
    }
}

//MARK: - Location Manager Delegate

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
            locationManager.stopUpdatingLocation()
            weatherManager.fetchWeather(location, units: units)
            weatherForecastManager.fetchForecast(location, units: units)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func registerTableViewCells() {
        let tableViewCell = UINib(nibName: "MainTableViewCell", bundle: nil)
        self.mainForecastTable.register(tableViewCell, forCellReuseIdentifier: K.mainScreenCellID)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfForecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.mainScreenCellID, for: indexPath) as! MainTableViewCell
        let date = Date(timeIntervalSince1970: TimeInterval(arrayOfForecasts[indexPath.row].dt))
        
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEE")
        
        cell.dayLabel.text = dateFormatter.string(from: date)
        
        cell.conditionsImage.image = UIImage(systemName: arrayOfForecasts[indexPath.row].conditionName)
        
        cell.highLabel.text = units == K.imperial ? String(format: "%.0f", arrayOfForecasts[indexPath.row].main.temp_max) + "℉" : String(format: "%.0f", arrayOfForecasts[indexPath.row].main.temp_max) + "℃"
        cell.lowLabel.text = units == K.imperial ? String(format: "%.0f", arrayOfForecasts[indexPath.row].main.temp_min) + "℉" : String(format: "%.0f", arrayOfForecasts[indexPath.row].main.temp_min) + "℃"
        
        return cell
        
        
        
    }
    
    
    
}
//MARK: - Settings View Delegate

extension MainViewController: SettingsViewDelegate {
    func changeUnits(units: String) {
        self.units = units
        defaults.set(units, forKey: K.Defaults.units)
        guard let myLocation = self.location else {return}
        weatherManager.fetchWeather(myLocation, units: units)
        weatherForecastManager.fetchForecast(myLocation, units: units)
        //        DispatchQueue.main.async {
        //            self.mainForecastTable.reloadData()
        //        }
    }
    
    func changeBackgroundColor(color: String) {
        view.backgroundColor = UIColor(named: color)
        defaults.set(color, forKey: K.Defaults.color)
        
    }
    
    
}
