//
//  PositioningViewController.swift
//  MarsOne
//
//  Created by Brandon Boynton on 1/21/17.
//  Copyright © 2017 MostBeastlyStudios. All rights reserved.
//

import UIKit
import CoreLocation

class PositioningViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var latLbl:UILabel!
    @IBOutlet weak var lonLbl:UILabel!
    @IBOutlet weak var baseCampDistenceLbl:UILabel!
    @IBOutlet weak var compassImg:UIImageView!
    @IBOutlet weak var timeLbl:UILabel!
    @IBOutlet weak var solLbl:UILabel!
    @IBOutlet weak var segmentedControl:UISegmentedControl!
    
    let locationManager = CLLocationManager()
    var isNorth = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        if locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.requestWhenInUseAuthorization()
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.sendData), userInfo: nil, repeats: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let baseCampCo = CLLocation(latitude: 40.42889316109785, longitude: -86.92342042922974)
        let currentLat = locationManager.location?.coordinate.latitude
        latLbl.text = "Lat: \(currentLat!)"
        let currentLon = locationManager.location?.coordinate.longitude
        lonLbl.text = "Lon: \(currentLon!)"
        UserDefaults.standard.set(currentLat, forKey: "lat")
        UserDefaults.standard.set(currentLon, forKey: "lon")
        let distance = baseCampCo.distance(from: locationManager.location!)
        baseCampDistenceLbl.text = "\(round(distance)) meters"
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print(newHeading)
        let currentLoc = locationManager.location?.coordinate
        
        var destination = CLLocation()
        if !isNorth {
            destination = CLLocation(latitude: 40.42889316109785, longitude: -86.92342042922974)
            if currentLoc != nil {
                let latestBearing = self.getHeadingForDirectionFromCoordinate(fromLoc:currentLoc!, toLoc: destination.coordinate)
                let degrees = latestBearing - newHeading.magneticHeading
                let cgaRotate = CGAffineTransform(rotationAngle: CGFloat(self.degreesToRadians(degrees: degrees)))
                compassImg.transform = cgaRotate
            }
        } else {
            let degrees = newHeading.magneticHeading
            let cgaRotate = CGAffineTransform(rotationAngle: CGFloat(self.degreesToRadians(degrees: degrees)))
            compassImg.transform = cgaRotate
        }
    }
    
    @IBAction func indexChanged(sender:UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                isNorth = false
            case 1:
                isNorth = true
            default:
                break;
            }
        }
    
    func getHeadingForDirectionFromCoordinate(fromLoc: CLLocationCoordinate2D, toLoc: CLLocationCoordinate2D) -> Double {
        let lat1 = self.degreesToRadians(degrees: fromLoc.latitude)
        let lon1 = self.degreesToRadians(degrees: fromLoc.longitude)
        let lat2 = self.degreesToRadians(degrees: toLoc.latitude)
        let lon2 = self.degreesToRadians(degrees: toLoc.longitude)
        let dLon = lon2 - lon1
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        var radiansBearing = atan2(y,x)
        
        if radiansBearing < 0.0 {
            radiansBearing += 2*M_PI
        }
        
        return self.radiansToDegrees(radians: radiansBearing)
    }
    
    func degreesToRadians(degrees: Double) -> Double {
        return degrees * M_PI / 180.0
    }
    
    func radiansToDegrees(radians: Double) -> Double {
        return radians * 180.0/M_PI
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
    
    func sendData() {
        let def = UserDefaults.standard
        
        let parameters = ["steps":def.integer(forKey: "number_of_steps"),
                          "distance":def.integer(forKey: "distance"),
                          "heart_rate":def.integer(forKey: "heart_beat"),
                          "avg_heart_rate":def.integer(forKey: "avg_heart_beat"),
                          "oxygen_life":def.float(forKey: "oxygen_life"),
                          "oxygen_time":def.integer(forKey: "current_oxygen"),
                          "lat":def.double(forKey: "lat"),
                          "lon":def.double(forKey: "lon")
            ] as [String : Any]
        
        print("http://10.0.1.5:3000/api/v1/users/update/\(UserDefaults.standard.string(forKey: "id")!)")
        let r = Just.patch("http://10.0.1.5:3000/api/v1/users/update/\(UserDefaults.standard.string(forKey: "id")!)", params: parameters, headers: ["X-User-Email":UserDefaults.standard.string(forKey: "email")!, "X-User-Token":UserDefaults.standard.string(forKey: "auth_token")!])
        print(r)
        if r.ok {
            print(r.json!)
            let data = r.json! as! NSDictionary
            
            UserDefaults.standard.set(((r.json as! NSDictionary)["mission"] as! String), forKey: "mission")
            
            let newAlertTitle = data["alert_title"] as! String
            let oldAlertTitle = UserDefaults.standard.string(forKey: "alert_title")
            
            if newAlertTitle != oldAlertTitle {
                let alert = (data["alert"] as! String)
                let title = (data["alert_title"] as! String)
                self.presentAlert(title: title, message: alert)
                UserDefaults.standard.set(title, forKey: "alert_title")
                UserDefaults.standard.set(alert, forKey: "alert")
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentAlert(title: String, message:String) {
        //alert
        if #available(iOS 8.0, *) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertView()
            alert.delegate = self
            alert.title = title
            alert.message = message
            alert.tag = 1
            alert.addButton(withTitle: "Okay")
            alert.show()
        }
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
