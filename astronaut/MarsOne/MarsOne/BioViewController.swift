//
//  BioViewController.swift
//  MarsOne
//
//  Created by Brandon Boynton on 1/20/17.
//  Copyright © 2017 MostBeastlyStudios. All rights reserved.
//

import UIKit

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
        
        if UserDefaults.standard.object(forKey: "current_oxygen") == nil {
            UserDefaults.standard.set(currentOx, forKey: "current_oxygen")
        }

        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateOxygen), userInfo: nil, repeats: true)
    }
    
    func updateOxygen() {
        currentOx = currentOx - 1
        let oxPerc = round((Float(currentOx) / Float(startOx))*1000) / 10
        oxLife.text = "Oxygen life: \(oxPerc)%"
        let hours = Int(currentOx) / 3600
        let minutes = Int(currentOx) / 60 % 60
        let seconds = Int(currentOx) % 60
        oxTime.text = String(format:"Oxygen time: %02i:%02i:%02i", hours, minutes, seconds)
        
        if currentOx == 1200 {
            self.presentAlert(title: "ALERT", message: "Low oxygen. Return to base camp immediately!")
        }
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
