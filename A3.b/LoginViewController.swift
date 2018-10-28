//
//  LoginViewController.swift
//  A3.b
//
//  Created by Hongyu Lin on 14/10/18.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit
//import FirebaseAuth
import Firebase
//import FirebaseCore

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var raspberryID: String?
    
    //var handle = AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Auth.auth().removeStateDidChangeListener(handle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        guard let password = passwordTextField.text else{
            displayErrorMessage("Please enter a password")
            return
        }
        guard let email = emailTextField.text else{
            displayErrorMessage("Please enter an email")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password){ (user, error) in
            if error != nil{
                self.displayErrorMessage(error!.localizedDescription)
            }
            else{
                let ref = Database.database().reference()
                ref.child("RaspberryMatchTable").queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value) { (snapShot) in
                    if let items = snapShot.value as? [String: AnyObject]{
                        for item in items{
                            //let emailA = item.value["email"] as! String
                            self.raspberryID = item.value["raspberryID"] as! String
                            }
                        self.performSegue(withIdentifier: "loginSegue", sender: self.raspberryID)
                        }
                    }
            }
        }        
    }
    
    func displayErrorMessage(_ errorMessage: String?){
        let allertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        allertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(allertController,animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue"{
            print("+++++++++++++++++++++++3")
            print(self.raspberryID)
            let controller = segue.destination as! HomeViewController
            controller.raspberryID = raspberryID
        }
    }
    

}
