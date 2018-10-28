//
//  FamilyTableViewController.swift
//  A3.b
//
//  Created by Hongyu Lin on 14/10/18.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit
import Firebase

class FamilyListTableViewController: UITableViewController {

    var raspberryID: String?
    var personList: [Person] = []
    var personCell: PersonTableViewCell?
    var ref = Database.database().reference().child("assignment3-2bbc1")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        print(personList.count)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return personList.count
    }

    func loadData(){
        ref.child(raspberryID!).child("member").observeSingleEvent(of: .value) { (snapShot) in
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
                    
                    let person = Person(user_id: userID, email: email, name: name, password: password, dob: dob,  portrait: portrait, gender: gender, registerDate: registerDate, height: height, weight: weight, data: bodyData)
                    print(person.name)
                    
                    self.personList.append(person)
                    print("------- count")
                    print(self.personList.count)
                    
                }
               self.tableView.reloadData()
            }
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print ("--- table view is loading")
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! PersonTableViewCell
        
        let person: Person = self.personList[indexPath.row]
        cell.nameLabel.text = person.name
//        
//        var string = person.portrait!
//        string.remove(at: string.startIndex)
//        let imageData = NSData(base64Encoded: string, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
//        cell.portraitImage.image = UIImage(data: imageData! as Data)!
//        
//        let featureData = person.data.last
//        
//        cell.heightLabel.text = "\(String(describing: featureData?.height))"
//        cell.weightLabel.text = "\(String(describing: featureData?.weight))"
//        
//        cell.dateLabel.text = Date.init(timeIntervalSince1970: (featureData?.dateTime)!).description
        return cell
    }
    
    // Define the height of the cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
