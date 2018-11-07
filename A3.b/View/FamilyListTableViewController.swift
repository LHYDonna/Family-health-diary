//
//  FamilyTableViewController.swift
//  A3.b
//
//  Created by Hongyu Lin on 14/10/18.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit
import Firebase

protocol UserSelectingDelegate{
    func setSelectedUser(user: Person)
}

class FamilyListTableViewController: UITableViewController {

    var person: Person?
    var personList: [Person] = []
    var personCell: PersonTableViewCell?
    var ref = Database.database().reference().child("RaspberryRepository")
    var chooseModel:Bool = false
    var userSelectingDelegate:UserSelectingDelegate?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    // initial page
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        self.setupActivityHandler()
        self.view.backgroundColor = .clear
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return personList.count
    }

    // load family mumber data from the firebase based on raspberryID
    func loadData(){
        ref.child(person!.raspberryID!).child("member").observeSingleEvent(of: .value) { (snapShot) in
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
                    let raspberry = item.value["raspberryID"] as! String
                    let registerDate = item.value["registerDate"] as! Double
                    var bodyData: [BodyFeature] = []
                    if let itemData = item.value["data"] as? [String: AnyObject]{
                        var bodyFeature: BodyFeature?
                        for oneData in itemData{
                            let date = oneData.value["created_date"] as! Double
                            let photo = oneData.value["photo"] as! String
                            let height = oneData.value["height"] as! Double
                            let weight = oneData.value["wight"] as! Double
                            let photoID = oneData.value["photoID"] as! String
                            let id = oneData.value["userID"] as! Int
                            bodyFeature = BodyFeature(user_id: id, dateTime: date, height: height, weight: weight, photo: photo, photoID: photoID)
                            bodyData.append(bodyFeature!)
                        }
                    }
                    let person = Person(user_id: userID, email: email, name: name, password: password, dob: dob,  portrait: portrait, gender: gender, registerDate: registerDate, height: height, weight: weight, raspberryID: raspberry, data: bodyData)
                    self.personList.append(person)
                }
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.tableView.reloadData()
            }
        }
        
        
    }
    
    // set value to each cells in the table view controller
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print ("--- table view is loading")
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! PersonTableViewCell
        cell.backgroundColor = .clear
        let person: Person = self.personList[indexPath.row]
        cell.nameLabel.text = person.name
      
        var string = person.portrait!
        if (string.elementsEqual("Default")){
            cell.portraitImage.image = UIImage.init(named: "default")
        }
        else{
            if (string.first == "b"){
                string.remove(at: string.startIndex)
            }
            let imageData = NSData(base64Encoded: string, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
            cell.portraitImage.image = UIImage(data: imageData! as Data)!
            cell.portraitImage.roundedImage()
        }
        
        if (person.data.count != 0){
        let featureData = person.data.last
        
            cell.heightLabel.text = "\(String(describing: featureData!.height!))"
            cell.weightLabel.text = "\(String(describing: featureData!.weight!))"
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/YYYY"
            cell.dateLabel.text = formatter.string(from: Date(timeIntervalSince1970: (featureData?.dateTime)!))
        }
        else{
            cell.heightLabel.text = person.height
            cell.weightLabel.text = person.weight
            cell.dateLabel.text = "NOT TAKEN YET"
        }
        return cell
    }
    
    // Define the height of the cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if chooseModel {
            self.userSelectingDelegate?.setSelectedUser(user: personList[indexPath.row])
            _ = navigationController?.popViewController(animated: true)
        }else{
        }
    }
    
    // set up activity handler
    func setupActivityHandler()
    {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }

}
