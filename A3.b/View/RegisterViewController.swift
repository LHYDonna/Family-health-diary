//
//  RegisterViewController.swift
//  A3.b
//
//  Created by Hongyu Lin on 14/10/18.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit
import Firebase
//import CoreData
//import FirebaseAuth

class RegisterViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var respberryTextfield: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var personList: [Person] = []
    var person_idList: [Int] = []
    var gender = "Male"
    
    var ref = Database.database().reference()
    //var handle: DatabaseHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.image = UIImage(named: "background")
        //getAllPerson()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func portraitPickerLocal(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = false
        self.present(picker, animated: true){
            //
        }
    }
    @IBAction func portraitPickerTake(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        picker.sourceType = UIImagePickerControllerSourceType.camera
        picker.allowsEditing = false
        self.present(picker, animated: true){
            //
        }
    }
    
    // pick image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            photoImageView.image = image
            //print(strBase64)
        }
        else{
            // Error Message
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func indexChangedSeg(_ sender: Any) {
        switch genderSegment.selectedSegmentIndex
        {
        case 0:
            gender = "Male";
        case 1:
            gender = "Female";
        default:
            break
        }
    }
    
    // register button
    // take a validation to all the inputed data
    // If all the data is legal, create a person to firebase
    @IBAction func registerBtn(_ sender: Any) {
        let raspberryID = respberryTextfield.text
        let name = nameTextField.text
        var portrait = "Default"
        if photoImageView.image != nil {
            let imageData:Data = UIImagePNGRepresentation(photoImageView.image!)!
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            portrait = strBase64
        }
        let dob = datePicker.date.timeIntervalSince1970
        let email = emailTextfield.text
        let password = passwordTextField.text
        let registerDate = Date.timeIntervalBetween1970AndReferenceDate
        let height = heightTextField.text
        let weight = weightTextField.text
        let userID = generateId()
        
        let validation: Validation? = Validation()
        if !(validation?.checkNameValid(name!))!{
            createAltert(title: "Invalid Name", message: "Input a valid name please!")
            return
        }
        if !(validation?.checkRaspberryIDValid(raspberryID!))!{
            createAltert(title: "Invalid ID", message: "Input a valid raspberryID please!")
            return
        }
        if !(validation?.checkNumberValid(height!))!{
            createAltert(title: "Invalid Height", message: "Input a valid number please!")
            return
        }
        if !(validation?.checkNumberValid(weight!))!{
            createAltert(title: "Invalid Weight", message: "Input a valid number please!")
            return
        }
        else{
            print("Pass Test")
            let person = Person(user_id: userID, email: email, name: password,password: name, dob: dob,  portrait: portrait, gender: gender, registerDate: registerDate, height: height, weight: weight,raspberryID: raspberryID, data: [])
            person.toString()
            personList.append(person)
            person_idList.append(person.user_id!)
            Auth.auth().createUser(withEmail: email!, password: password!) { (authResult, error) in
                if error != nil{
                    self.displayErrorMessage(error!.localizedDescription)
                }
            }
            let personData = ["userID": userID,
                              "name": name,
                              "portrait": portrait,
                              "dob": dob,
                              "email": email,
                              "password": password,
                              "registerDate": registerDate,
                              "height": height,
                              "weight": weight,
                              "gender": gender,
                              "raspberryID": raspberryID,
                              "data": []] as [String : Any]
            let matchData = [ "email": email,
                              "raspberryID": raspberryID] as [String : Any]
            self.ref.child("RaspberryRepository").child(raspberryID!).child("member").child(String(userID)).setValue(personData)
            self.ref.child("RaspberryMatchTable").childByAutoId().setValue(matchData)
        }
        createAltert(title: "Create Account", message: "Successfully!")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginPage") as! LoginViewController
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    // display error messages function
    func displayErrorMessage(_ errorMessage: String?){
        let allertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        allertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(allertController,animated: true, completion: nil)
    }
    
    // Create alert
    func createAltert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // function used to generate a unique user id
    func generateId() -> Int{
        var bool = true
        var id = -1
        while (id == -1 || bool == false){
            id = Int(arc4random_uniform(10000000))
            for person_id in person_idList{
                if (id == person_id){
                    bool = false
                    break
                }
            }
        }
        return id
    }
    

}
