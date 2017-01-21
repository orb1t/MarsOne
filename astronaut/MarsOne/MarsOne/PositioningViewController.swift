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
    
    let locationManager = CLLocationManager()

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
        
        let baseCampCo = CLLocation(latitude: 40.42889316109785, longitude: -86.92342042922974)
        let latestBearing = self.getHeadingForDirectionFromCoordinate(fromLoc: (locationManager.location?.coordinate)!, toLoc: baseCampCo.coordinate)
        let degrees = latestBearing - newHeading.magneticHeading
        let cgaRotate = CGAffineTransform(rotationAngle: CGFloat(self.degreesToRadians(degrees: degrees)))
        compassImg.transform = cgaRotate
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
