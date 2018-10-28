//
//  HomeViewController.swift
//  A3.b
//
//  Created by Hongyu Lin on 14/10/18.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit
import Firebase

protocol ManagePersonProtocol{
    func editPersonFile(person: Person)
}

class HomeViewController: UIViewController ,ManagePersonProtocol{
    
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var portraitImage: UIImageView!
    
    
    var ref = Database.database().reference().child("assignment3-2bbc1")
    var person: Person?
    var raspberryID = "raspberry"

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentUser()
        // Do any additional setup after loading the view.
    }
    
    func editPersonFile(person: Person) {
        self.person = person
        namelabel.text = person.name
//        var string = person.portrait!
//        string.remove(at: string.startIndex)
//        let imageData = NSData(base64Encoded: string, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
//        portraitImage.image = UIImage(data: imageData! as Data)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchCurrentUser(){
        let email = Auth.auth().currentUser?.email
        ref.child("raspberry").child("member").queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value) { (snapShot) in
            if let items = snapShot.value as? [String: AnyObject]{
                for item in items{
                    let userID = item.value["userID"] as! Int
                    let name = item.value["name"] as! String
                    let email = item.value["email"] as! String
                    let password = item.value["password"] as! String
                    let gender = item.value["gender"] as! String
                    let portrait = item.value["portrait"] as! String
                    let height = item.value["height"] as! String
                    let weight = item.value["weight"] as! String
                    let dob = item.value["dob"] as! Double
                    let registerDate = item.value["registerDate"] as! Double
                    var bodyData: [BodyFeature] = []
                    if let itemData = item.value["data"] as? [String: AnyObject]{
                        var bodyFeature: BodyFeature?
                        for oneData in itemData{
                            //print("=================")
                            //print(oneData.value["create_date"])
                            let date = oneData.value["created_date"] as! Double
                            let photo = oneData.value["photo"] as! String
                            let height = oneData.value["height"] as! Double
                            let weight = oneData.value["wight"] as! Double
                            let photoID = oneData.value["photoID"] as! Int
                            let id = oneData.value["userID"] as! Int
                            bodyFeature = BodyFeature(user_id: id, dateTime: date, height: height, weight: weight, photo: photo, photoID: photoID)
                            bodyData.append(bodyFeature!)
                        }
                    }
                    
                    self.person = Person(user_id: userID, email: email, name: name, password: password, dob: dob,  portrait: portrait, gender: gender, registerDate: registerDate, height: height, weight: weight, data: bodyData)
                    print("++++++++++++++")
                    print(bodyData.count)
                    self.namelabel.text = self.person?.name
                    var string = self.person?.portrait!
                    string!.remove(at: (string?.startIndex)!)
                    let imageData = NSData(base64Encoded: string!, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
                    self.portraitImage.image = UIImage(data: imageData! as Data)!
                }
            }
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "personFileEditSegue"{
            let controller = segue.destination as! PersonalFileViewController
            controller.editpersonDelegate = self
            controller.person = person
        }
        if segue.identifier == "todaySegue"{
            let controller = segue.destination as! TodayViewController
            controller.showPersonDelegate = self
            controller.person = person
        }
        if segue.identifier == "videoSegue"{
            let controller = segue.destination as! MakeVideoViewController
            controller.personDelegate = self
            controller.person = person
        }
        if segue.identifier == "familySegue"{
            let controller = segue.destination as! FamilyListTableViewController
            controller.raspberryID = raspberryID
        }
    }


}
