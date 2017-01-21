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

    override func viewDidLoad() {
        super.viewDidLoad()
        //get mission brief from master data and display it
        
        let r = Just.get("http://10.0.1.5:3000/api/v1/users/get_alert", params: [:], headers: ["X-User-Email":UserDefaults.standard.string(forKey: "email")!, "X-User-Token":UserDefaults.standard.string(forKey: "auth_token")!])
        print(r)
        print(r.json)
    }
    
    @IBAction func alertButton() {
        //Get alert data from master data and display it
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
