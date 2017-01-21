//
//  LoginViewController.swift
//  MarsOne
//
//  Created by Brandon Boynton on 1/20/17.
//  Copyright © 2017 MostBeastlyStudios. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginField:UITextField!
    @IBOutlet weak var passwordField:UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButton() {
        let r = Just.post("http://10.0.1.5:3000/api/v1/users/sign_in", params: [:], headers: ["email":loginField.text!,"password":passwordField.text!])
        print(r)
        if r.ok {
            print(r.json!)
            let userData = r.json! as! NSDictionary
            UserDefaults.standard.set(userData["authentication_token"] as! String, forKey: "auth_token")
            UserDefaults.standard.set(userData["email"] as! String, forKey: "email")
            UserDefaults.standard.set(userData["id"] as! String, forKey: "id")
            self.performSegue(withIdentifier: "login_to_bio", sender: self)
        } else {
            self.presentAlert(title: "Error", message: "Invalid username or password")
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
