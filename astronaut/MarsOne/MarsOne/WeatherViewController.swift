//
//  WeatherViewController.swift
//  MarsOne
//
//  Created by Brandon Boynton on 1/21/17.
//  Copyright © 2017 MostBeastlyStudios. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var earthTime:UILabel!
    @IBOutlet weak var earthDate:UILabel!
    @IBOutlet weak var timeLbl:UILabel!
    @IBOutlet weak var solLbl:UILabel!
    
    @IBOutlet weak var minTempC:UILabel!
    @IBOutlet weak var minTempF:UILabel!
    @IBOutlet weak var maxTempC:UILabel!
    @IBOutlet weak var maxTempF:UILabel!
    @IBOutlet weak var pressure:UILabel!
    @IBOutlet weak var sunrise:UILabel!
    @IBOutlet weak var sunset:UILabel!
    
    var weatherData:NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()

        let r = Just.get("http://10.0.1.5:3000/api/v1/mars_report/show_latest")
        weatherData = r.json! as! NSDictionary
        print(weatherData)
        minTempC.text = "Min temp (C): \(weatherData["min_temp"] as! Float)"
        minTempF.text = "Min temp (F): \(weatherData["min_temp_fahrenheit"] as! Float)"
        maxTempC.text = "Max temp (C): \(weatherData["max_temp"] as! Float)"
        maxTempF.text = "Max temp (F): \(weatherData["max_temp_fahrenheit"] as! Float)"
        pressure.text = "Pressure: \(weatherData["pressure"] as! Int) mmHg"
        sunrise.text = "Sunrise: \(weatherData["sunrise"] as! String)"
        sunset.text = "Sunset: \(weatherData["sunset"] as! String)"
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateEarthTime), userInfo: nil, repeats: true)
    }
    
    func updateEarthTime() {
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        let midnight = cal.startOfDay(for: date)
        let sinceMidnight = NSDate().timeIntervalSince(midnight)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        earthDate.text = "Earth date: \(dateFormatter.string(from: date))"
        
        let hours = Int(sinceMidnight) / 3600
        let minutes = Int(sinceMidnight) / 60 % 60
        let seconds = Int(sinceMidnight) % 60
        
        DispatchQueue.main.async {
            self.earthTime.text = String(format:"Earth Time: %02i:%02i:%02i", hours, minutes, seconds)
        }
    }
    
    func updateTime() {
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        let midnight = cal.startOfDay(for: date)
        let sinceMidnight = (NSDate().timeIntervalSince(midnight) * 1.027491252) + 9620
        
        let hours = Int(sinceMidnight) / 3600
        let minutes = Int(sinceMidnight) / 60 % 60
        let seconds = Int(sinceMidnight) % 60
        
        DispatchQueue.main.async {
            self.timeLbl.text = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
