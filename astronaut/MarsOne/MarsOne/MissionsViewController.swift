//
//  MissionsViewController.swift
//  MarsOne
//
//  Created by Brandon Boynton on 1/21/17.
//  Copyright © 2017 MostBeastlyStudios. All rights reserved.
//

import UIKit

class MissionsViewController: UIViewController {
    @IBOutlet weak var alertButon:UIButton!
    @IBOutlet weak var missionBrief:UITextView!
    @IBOutlet weak var timeLbl:UILabel!
    @IBOutlet weak var solLbl:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        //get mission brief from master data and display it
        
        let r = Just.get("http://10.0.1.5:3000/api/v1/users/get_alert", params: [:], headers: ["X-User-Email":UserDefaults.standard.string(forKey: "email")!, "X-User-Token":UserDefaults.standard.string(forKey: "auth_token")!])
        print(r)
        print(r.json!)
        
        let title = UserDefaults.standard.string(forKey: "alert_title")
        self.alertButon.setTitle(title, for: .normal)
        
        self.missionBrief.text = UserDefaults.standard.string(forKey: "mission")
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    }
    
    @IBAction func alertButton() {
        let alert = UserDefaults.standard.string(forKey: "alert")
        let title = UserDefaults.standard.string(forKey: "alert_title")
        self.presentAlert(title: title!, message: alert!)
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
