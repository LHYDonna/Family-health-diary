//
//  PersonalFileViewController.swift
//  A3.b
//
//  Created by Hongyu Lin on 14/10/18.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit
import Firebase

class PersonalFileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var editpersonDelegate: ManagePersonProtocol?
    var person: Person?
    var gender = "Male"
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var portraitImage: UIImageView!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var sexSegment: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func showData(){
        nameTextField.text = person?.name
//        var string = person?.portrait!
//        string!.remove(at: (string?.startIndex)!)
//        let imageData = NSData(base64Encoded: string!, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
//        portraitImage.image = UIImage(data: imageData! as Data)!
        showPortrait()
        heightTextField.text = person?.height
        weightTextField.text = person?.weight
        var genderIndex: Int
        if (person?.gender?.elementsEqual("Male"))!{
            genderIndex = 0
        }
        else{
            genderIndex = 1
        }
        sexSegment.selectedSegmentIndex = genderIndex
       
        datePicker.date = Date.init(timeIntervalSince1970: (person?.dob)!)
    }
    
    func showPortrait(){
        var string = person?.portrait!
        if (string!.elementsEqual("Default")){
            portraitImage.image = UIImage.init(named: "default")
        }
        else{
            if (string!.first == "b"){
                string!.remove(at: (string?.startIndex)!)
            }
            let imageData = NSData(base64Encoded: string!, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
            portraitImage.image = UIImage(data: imageData! as Data)!
        }
    }

    @IBAction func segmentSelectBtn(_ sender: Any) {
        switch sexSegment.selectedSegmentIndex
        {
        case 0:
            gender = "Male";
        case 1:
            gender = "Female";
        default:
            break
        }
    }
    
    @IBAction func updateFigureBtn(_ sender: Any) {
        nameTextField.text = person?.name
        let todayFeature = person?.data.last
        heightTextField.text = "\(String(describing: todayFeature!.height!))"
        weightTextField.text = "\(String(describing: todayFeature!.weight!))"
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            portraitImage.image = image
            //print(strBase64)
        }
        else{
            // Error Message
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateFileBtn(_ sender: Any) {
        updatePerson()
        ref.child("RaspberryRepository").child((person?.raspberryID)!).child("member").child("\(String(describing: person!.user_id!))").updateChildValues(["name" : nameTextField.text,                                                                 "portrait" : person?.portrait, "height": heightTextField.text,"weight": weightTextField.text,"gender": gender,"dob": person?.dob])
        editpersonDelegate?.editPersonFile(person: person!)
    }
    
    func updatePerson(){
        let validation: Validation? = Validation()
        if !(validation?.checkNameValid(nameTextField.text!))!{
            createAltert(title: "Invalid Name", message: "Input a valid name please!")
            return
        }
        if !(validation?.checkNumberValid(heightTextField.text!))!{
            createAltert(title: "Invalid Height", message: "Input a valid number please!")
            return
        }
        if !(validation?.checkNumberValid(weightTextField.text!))!{
            createAltert(title: "Invalid Weight", message: "Input a valid number please!")
            return
        }
        else{
            person?.name = nameTextField.text
            let imageData:Data = UIImagePNGRepresentation(portraitImage.image!)!
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            person?.portrait = strBase64
            person?.height = heightTextField.text
            person?.weight = weightTextField.text
            person?.gender = gender
            person?.dob = datePicker.date.timeIntervalSince1970
        }
    }
    
    // Create alert
    func createAltert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
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
