//
//  BioViewController.swift
//  MarsOne
//
//  Created by Brandon Boynton on 1/20/17.
//  Copyright © 2017 MostBeastlyStudios. All rights reserved.
//

import UIKit
import HealthKit
import CoreMotion
import CoreLocation
import AVFoundation

class BioViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var timeLbl:UILabel!
    @IBOutlet weak var solLbl:UILabel!
    @IBOutlet weak var oxLife:UILabel!
    @IBOutlet weak var oxTime:UILabel!
    @IBOutlet weak var stepsWalked:UILabel!
    @IBOutlet weak var distenceWalked:UILabel!
    @IBOutlet weak var currHeartRate:UILabel!
    @IBOutlet weak var avgHeartRate:UILabel!
    @IBOutlet weak var heartbeat:UIImageView!
    
    let startOx = 7200
    var currentOx = 7200
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get healthkit data permission
        let healthStore: HKHealthStore? = {
            if HKHealthStore.isHealthDataAvailable() {
                return HKHealthStore()
            } else {
                return nil
            }
        }()
        
        //let player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath:Bundle.main.path(forResource: "siren", ofType: "mp3")!))
        //player?.play()
        
        
        
//        do {
//            avPlayer = AVPlayer(URL: url)
//            
//            
//        } catch let error {
//            print(error.localizedDescription)
//        }
        
        let imageData = try? Data(contentsOf: Bundle(for: BioViewController.self).url(forResource: "heartbeat", withExtension: ".gif")!) as Data
        heartbeat.image = UIImage.gif(data: imageData!)
        //heartbeat.layer.borderWidth = 2
        //heartbeat.layer.borderColor = UIColor(colorLiteralRed: 247, green: 225, blue: 201, alpha: 80).cgColor
        
        self.updateBPM()
        
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        let heartRate = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        let distance = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
        
        let dataTypesToWrite = NSSet(object: stepsCount)
        let dataTypesToRead = NSSet(objects: stepsCount, heartRate, distance) //NSSet(object: stepsCount!)
        
        healthStore?.requestAuthorization(toShare: dataTypesToWrite as? Set<HKSampleType>,
                                          read: dataTypesToRead as? Set<HKObjectType>,
                                                      completion: { [unowned self] (success, error) in
                                                        if success {
                                                        } else {
                                                            
                                                        }
        })
        
        //Set default O2
        if UserDefaults.standard.object(forKey: "current_oxygen") == nil || (UserDefaults.standard.object(forKey: "current_oxygen") as! Int) <= 0 {
            UserDefaults.standard.set(currentOx, forKey: "current_oxygen")
        }
        
        currentOx = UserDefaults.standard.integer(forKey: "current_oxygen")
        
        //location
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()

        //Set update timers
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateOxygen), userInfo: nil, repeats: true)
        self.updateSteps()
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateSteps), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.updateBPM), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.sendData), userInfo: nil, repeats: true)
    }
    
    func updateOxygen() {
        currentOx = currentOx - 1
        UserDefaults.standard.set(currentOx, forKey: "current_oxygen")
        let oxPerc = round((Float(currentOx) / Float(startOx))*1000) / 10
        UserDefaults.standard.set(oxPerc, forKey: "oxygen_life")
        oxLife.text = "Oxygen life: \(oxPerc)%"
        let hours = Int(currentOx) / 3600
        let minutes = Int(currentOx) / 60 % 60
        let seconds = Int(currentOx) % 60
        oxTime.text = String(format:"Oxygen time: %02i:%02i:%02i", hours, minutes, seconds)
        
        if currentOx == 1200 {
            self.presentAlert(title: "ALERT", message: "Low oxygen. Return to base camp immediately!")
        }
        
        if currentOx == 0 {
            self.presentAlert(title: "ALERT", message: "You done got yourself killed.")
        }
        
        if currentOx <= 0 {
            currentOx = 0
        }
        
        var avPlayer: AVPlayer!
        
//        let url = Bundle.main.url(forResource: "siren", withExtension: "mp3")!
//        avPlayer = AVPlayer(url: url)
//        avPlayer.play()
        
//        var audioPlayer:AVAudioPlayer!
//        var audioFilePath = Bundle.main.path(forResource: "siren", ofType: "mp3")
//        
//        if audioFilePath != nil {
//            
//            var audioFileUrl = NSURL.fileURL(withPath: audioFilePath!)
//            
//            audioPlayer = AVAudioPlayer(contentsOfURL: audioFileUrl, error: nil)
//            audioPlayer.play()
//            
//        } else {
//            print("audio file is not found")
//        }
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
    
    //let pedometer:CMPedometer! = nil
    let pedometer = CMPedometer()
    let health: HKHealthStore = HKHealthStore()
    let heartRateUnit:HKUnit = HKUnit(from: "count/min")
    let heartRateType:HKQuantityType   = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
    var heartRateQuery:HKSampleQuery?
    
    func updateSteps() {
        pedometer.queryPedometerData(from: NSDate().addingTimeInterval(-86400) as Date, to: NSDate() as Date, withHandler: { (data, error) -> Void in
            
            if let data = data {
                let numSteps = data.numberOfSteps
                UserDefaults.standard.set(numSteps, forKey: "number_of_steps")
                let distance = data.distance!
                UserDefaults.standard.set(distance, forKey: "distance")
                
                DispatchQueue.main.async {
                    self.distenceWalked.text = "Distance walked: \(round(Double(distance))) ft"
                    self.stepsWalked.text = "Steps walked: \(numSteps)"
                }
            }
        })
    }
    
    var BPMArray = Array<Int>()
    
    func updateBPM() {
        let startDate = NSDate().addingTimeInterval(-86400) as Date
        let endDate = NSDate()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate as Date, options: [])
        
        //descriptor
        let sortDescriptors = [
            NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        ]
        
        heartRateQuery = HKSampleQuery(sampleType: heartRateType,
                                       predicate: predicate,
                                       limit: 25,
                                       sortDescriptors: sortDescriptors,
                                       resultsHandler: {(query, results, error) -> Void in
                                        //let resultsQ = results as? [HKQuantitySample]
                                        if let samples = results as? [HKQuantitySample]
                                        {
                                            if let quantity = samples.last?.quantity
                                            {
                                                self.BPMArray.append(Int(quantity.doubleValue(for: self.heartRateUnit)))
                                                UserDefaults.standard.set(Int(quantity.doubleValue(for: self.heartRateUnit)), forKey: "heart_beat")
                                                var sum = 0
                                                for i in 0...self.BPMArray.count-1 {
                                                    sum = sum + self.BPMArray[i]
                                                }
                                                let bpmAvg = round(Double(sum/self.BPMArray.count))
                                                UserDefaults.standard.set(bpmAvg, forKey: "avg_heart_beat")
                                                DispatchQueue.main.async {
                                                    self.currHeartRate.text = "Heart rate: \(round(quantity.doubleValue(for: self.heartRateUnit)))"
                                                    self.avgHeartRate.text = "Avg heart rate: \(round(bpmAvg))"
                                                }
                                            }
                                        }                                        
        })
        
        health.execute(heartRateQuery!)
    }

    
    @IBAction func resetOxygen() {
        currentOx = 7200
        UserDefaults.standard.set(7200, forKey: "current_oxygen")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLat = locationManager.location?.coordinate.latitude
        let currentLon = locationManager.location?.coordinate.longitude
        UserDefaults.standard.set(currentLat, forKey: "lat")
        UserDefaults.standard.set(currentLon, forKey: "lon")
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
                let sfxInt = (data["alert_sound"] as! Int)
                self.presentAlert(title: title, message: alert)
                
                var sfx = ""
                if sfxInt == 3 {
                    sfx = "siren"
                } else if sfxInt == 1 {
                    
                }
                
                let player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath:Bundle.main.path(forResource: sfx, ofType: "mp3")!))
                player?.play()
                
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
