//
//  PersonalFileViewController.swift
//  A3.b
//
//  Created by Hongyu Lin on 14/10/18.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit
import Firebase

class PersonalFileViewController: UIViewController {

    var editpersonDelegate: ManagePersonProtocol?
    var person: Person?
    var gender = "Male"
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var portraitImage: UIImageView!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var sexSegment: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var ref = Database.database().reference().child("assignment3-2bbc1")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showData(){
        nameTextField.text = person?.name
        var string = person?.portrait!
        string!.remove(at: (string?.startIndex)!)
        let imageData = NSData(base64Encoded: string!, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        portraitImage.image = UIImage(data: imageData! as Data)!
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
    
    @IBAction func updateFileBtn(_ sender: Any) {
        updatePerson()
        ref.child("raspberry").child("member").child("\(String(describing: person!.user_id!))").updateChildValues(["name" : nameTextField.text,                                                                 "height": heightTextField.text,"weight": weightTextField.text,"gender": gender,"dob": person?.dob])
        editpersonDelegate?.editPersonFile(person: person!)
    }
    
    func updatePerson(){
        person?.name = nameTextField.text
        person?.height = heightTextField.text
        person?.weight = weightTextField.text
        person?.gender = gender
        person?.dob = datePicker.date.timeIntervalSince1970
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
