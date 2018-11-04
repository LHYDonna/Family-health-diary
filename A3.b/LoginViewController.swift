//
//  LoginViewController.swift
//  A3.b
//
//  Created by Hongyu Lin on 14/10/18.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit
import Firebase


class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var raspberryID: String?
    //var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    // set email and password icon to the left of the textfiled
    override func viewDidLoad() {
        super.viewDidLoad()
        addLeftImageToTextField(emailTextField,UIImage(named: "email")!)
        addLeftImageToTextField(passwordTextField,UIImage(named: "password")!)
        // Do any additional setup after loading the view.
    }
    
    func addLeftImageToTextField(_ txtField: UITextField, _ img: UIImage){
        let leftImageView = UIImageView(frame: CGRect(x: 10.0, y: 0.0, width: img.size.width, height: img.size.height))
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always
    }
    
    // set the navigation bar disappear since we do not want it at the login page
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        //Auth.auth().removeStateDidChangeListener(handle)
    }
    
    // set back the navigation bar when leave this page since we want it in all other pages
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // set keyboard of when the user touches untypable places
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // set up login button
    // get password and email from textfield
    // connect to firebase to check if they are matched in firebase
    // If yes, get raspberryID from the firebase and jump to homepage view controller
    // If no, display error massages
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
                            self.raspberryID = item.value["raspberryID"] as! String
                            }
                        self.performSegue(withIdentifier: "loginSegue", sender: self.raspberryID)
                        }
                    }
            }
        }        
    }
    
    // use to diaplay user massages
    func displayErrorMessage(_ errorMessage: String?){
        let allertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        allertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(allertController,animated: true, completion: nil)
    }
    
    // when the user passed varification from firebase, take raspberry parameter and go to homeViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue"{
            print("+++++++++++++++++++++++3")
            print(self.raspberryID)
            let controller = segue.destination as! HomeViewController
            controller.raspberryID = raspberryID
        }
    }
    

}
