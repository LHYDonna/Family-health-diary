//
//  PasswordResetViewController.swift
//  A3.b
//
//  Created by Hongyu Lin on 14/10/18.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit
import Firebase

class PasswordResetViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.image = UIImage(named: "background")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // sent email to the user to reset his or her password if the email has been registered in the firebase
    @IBAction func sendEmailBtn(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!){error in
            if let error = error {
                self.displayErrorMessage(error.localizedDescription)
            } else {
                let allertController = UIAlertController(title: "Info", message: "Email Sent", preferredStyle: UIAlertControllerStyle.alert)
                allertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(allertController,animated: true, completion: nil)
            }
        }
    }
    
    // display error message
    func displayErrorMessage(_ errorMessage: String?){
        let allertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        allertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(allertController,animated: true, completion: nil)
    }

}
