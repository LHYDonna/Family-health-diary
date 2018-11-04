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
    
    
    var ref = Database.database().reference()
    var person: Person?
    var raspberryID: String?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentUser()
        setupActivityHandler()
        
        // Do any additional setup after loading the view.
    }
    
    func editPersonFile(person: Person) {
        self.person = person
        namelabel.text = person.name
        showPortrait()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupActivityHandler()
    {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func fetchCurrentUser(){
        let email = Auth.auth().currentUser?.email
        ref.child("RaspberryRepository").child(raspberryID!).child("member").queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value) { (snapShot) in
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
                    let raspberry = item.value["raspberryID"] as! String
                    let dob = item.value["dob"] as! Double
                    let registerDate = item.value["registerDate"] as! Double
                    var bodyData: [BodyFeature] = []
                    if let itemData = item.value["data"] as? [String: AnyObject]{
                        var bodyFeature: BodyFeature?
                        for oneData in itemData{
                            let date = oneData.value["created_date"] as! Double
                            let photo = "kk"
                            let height = oneData.value["height"] as! Double
                            let weight = oneData.value["wight"] as! Double
                            let photoID = oneData.value["photoID"] as! String
                            let id = oneData.value["userID"] as! Int
                            bodyFeature = BodyFeature(user_id: id, dateTime: date, height: height, weight: weight, photo: photo, photoID: photoID)
                            bodyData.append(bodyFeature!)
                        }
                    }
                    self.person = Person(user_id: userID, email: email, name: name, password: password, dob: dob,  portrait: portrait, gender: gender, registerDate: registerDate, height: height, weight: weight, raspberryID: raspberry, data: bodyData)
                    print("++++++++++++++")
                    print(bodyData.count)
                    self.namelabel.text = self.person?.name
                    self.showPortrait()
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                self.person?.data = (self.person?.data.sorted{Int($0.dateTime!) > Int($1.dateTime!)})!
            }
        }
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
            portraitImage.roundedImage()
        }
    }

    @IBAction func signoutBtn(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginPage") as! LoginViewController
            self.present(newViewController, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
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
            let controller = segue.destination as! ImageProcessingHomeViewController
            //controller.personDelegate = self
            controller.person = person
            controller.raspberryID = raspberryID
        }
        if segue.identifier == "chartSegue"{
            let controller = segue.destination as! ChartViewController
            controller.person = person
        }
        if segue.identifier == "familySegue"{
            let controller = segue.destination as! FamilyListTableViewController
            controller.person = person
        }
        if segue.identifier == "familyReportSegue"{
            let controller = segue.destination as! FamilyReportViewController
            controller.person = person
        }
        if segue.identifier == "gifGallerySegue"{
            let controller = segue.destination as! GifGalleryController
            controller.person = person
            controller.raspberryID = raspberryID
        }
        
    }


}
