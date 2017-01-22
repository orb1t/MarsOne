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
    @IBOutlet weak var timeLbl:UILabel!
    @IBOutlet weak var solLbl:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func updateEarthTime() {
        let since1970 = NSDate().timeIntervalSince1970
        let msSince1970 = NSInteger(since1970)
        
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        let midnight = cal.startOfDay(for: date)
        let sinceMidnight = NSDate().timeIntervalSince(midnight)
        
        let hours = Int(sinceMidnight) / 3600
        let minutes = Int(sinceMidnight) / 60 % 60
        let seconds = Int(sinceMidnight) % 60
        
        let mtc = Double(msSince1970 - 947116800) * (86400/88775.244) + 44795.9998
        print("earth: \(msSince1970)")
        print("mars: \(mtc)")
        
        DispatchQueue.main.async {
            self.earthTime.text = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        }
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
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
