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

class BioViewController: UIViewController {
    
    @IBOutlet weak var timeLbl:UILabel!
    @IBOutlet weak var solLbl:UILabel!
    @IBOutlet weak var oxLife:UILabel!
    @IBOutlet weak var oxTime:UILabel!
    @IBOutlet weak var stepsWalked:UILabel!
    @IBOutlet weak var distenceWalked:UILabel!
    @IBOutlet weak var currHeartRate:UILabel!
    @IBOutlet weak var avgHeartRate:UILabel!
    
    let startOx = 7200
    var currentOx = 7200

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
                                                            print("SUCCESS")
                                                        } else {
                                                            
                                                        }
        })
        
        //Set default O2
        if UserDefaults.standard.object(forKey: "current_oxygen") == nil {
            UserDefaults.standard.set(currentOx, forKey: "current_oxygen")
        }
        
        currentOx = UserDefaults.standard.integer(forKey: "current_oxygen")

        //Set update timers
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateOxygen), userInfo: nil, repeats: true)
        self.updateSteps()
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateSteps), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.updateBPM), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    }
    
    func updateOxygen() {
        currentOx = currentOx - 1
        UserDefaults.standard.set(currentOx, forKey: "current_oxygen")
        let oxPerc = round((Float(currentOx) / Float(startOx))*1000) / 10
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
                let distance = data.distance!
                
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
                                                var sum = 0
                                                for i in 0...self.BPMArray.count-1 {
                                                    sum = sum + self.BPMArray[i]
                                                }
                                                let bpmAvg = round(Double(sum/self.BPMArray.count))
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
