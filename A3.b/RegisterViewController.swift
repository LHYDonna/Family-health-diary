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

class RegisterViewController: UIViewController {

    
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
    
    var personList: [Person] = []
    var person_idList: [Int] = []
    var gender = "Male"
    
    var ref = Database.database().reference().child("assignment3-2bbc1")
    //var handle: DatabaseHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllPerson()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAllPerson(){
        
    }
    
    @IBAction func uploadPhotoBtn(_ sender: Any) {
        
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
    
    @IBAction func registerBtn(_ sender: Any) {
        let raspberryID = respberryTextfield.text
        let name = nameTextField.text
        let portrait = "Default"
        let dob = datePicker.date.timeIntervalSince1970
        let email = emailTextfield.text
        let password = passwordTextField.text
        let registerDate = Date.timeIntervalBetween1970AndReferenceDate
        let height = heightTextField.text
        let weight = weightTextField.text
        let userID = generateId()
        let person = Person(user_id: userID, email: email, name: password,password: name, dob: dob,  portrait: portrait, gender: gender, registerDate: registerDate, height: height, weight: weight, data: [])
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
                          "data": []] as [String : Any]
        
        self.ref.child(raspberryID!).child("member").child(String(userID)).setValue(personData)
    }
    
    func displayErrorMessage(_ errorMessage: String?){
        let allertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        allertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(allertController,animated: true, completion: nil)
    }
    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
