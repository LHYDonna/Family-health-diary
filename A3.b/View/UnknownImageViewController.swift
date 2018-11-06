//
//  UnknownImageViewController.swift
//  A3.b
//
//  Created by 张冬霖 on 2018/11/4.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit
import Firebase

class UnknownImageViewController: UIViewController,UserSelectingDelegate,UICollectionViewDataSource, UICollectionViewDelegate {
    
    var selectedUser: Person?
    var selectedImageID: String?
    var selectedFeature: BodyFeature?
    var ref = Database.database().reference()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var unknownFeatureList:[BodyFeature] = []
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var unknownCollection: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var userProtrait: UIImageView!
    var person:Person?
    var raspberryID:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedImage.image = UIImage(named: "who-is")
        self.userProtrait.image = UIImage(named: "who-is")
        self.getAllUnknownBodyFeatures()
        self.setupActivityHandler()
        // Do any additional setup after loading the view.
        self.background.image =  UIImage(named: "background")
        background.contentMode = .scaleToFill
        self.background.layer.zPosition = -1
        self.unknownCollection.backgroundColor = .clear
        
        self.userProtrait.layer.masksToBounds = true
        self.userProtrait.layer.borderWidth = 5
        self.userProtrait.layer.borderColor = UIColor.cyan.cgColor
        self.userProtrait.layer.cornerRadius = self.userProtrait.bounds.width / 3
        
        self.selectedImage.layer.masksToBounds = true
        self.selectedImage.layer.borderWidth = 5
        self.selectedImage.layer.borderColor = UIColor.cyan.cgColor
        self.selectedImage.layer.cornerRadius = self.selectedImage.bounds.width / 3

    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.unknownFeatureList.count
        
    }
    
    // set image cell to the collectionview
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "unknownImageCollectionCell", for: indexPath) as! ImageCollectionViewCell
        print (indexPath.row)
        // Configure the cell
        let oneFeature = self.unknownFeatureList[indexPath.row]
        let photoData = oneFeature.photo!
        let imageData = NSData(base64Encoded: photoData, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        cell.imageView.image = UIImage(data: imageData! as Data)
        cell.imageView.layer.masksToBounds = true
        cell.imageView.layer.borderWidth = 2.5
        cell.imageView.layer.borderColor = UIColor.green.cgColor
        cell.imageView.layer.cornerRadius = cell.imageView.bounds.width / 7
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let oneFeature = self.unknownFeatureList[indexPath.row]
        let photoData = oneFeature.photo!
        let imageData = NSData(base64Encoded: photoData, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        self.selectedImage.image = UIImage(data: imageData! as Data)
        self.selectedImageID = oneFeature.photoID!
        self.selectedFeature = oneFeature
    }
    
    func deleteUnknownImage(imageID: String){
        print ("----- func: delete one unknown photo")
        let raspberryID = person!.raspberryID
        self.ref.child("RaspberryRepository").child(raspberryID!).child("unknown_photo").queryOrdered(byChild: "photoID").queryEqual(toValue: imageID).observeSingleEvent(of: .value) { (snapShot) in
            if let items = snapShot.value as? [String: AnyObject]{
                for item in items{
                    print ("----- delete one unknow photo in \(snapShot.ref.child(item.key).description)")
                    snapShot.ref.child(item.key).removeValue()
                }
                self.getAllUnknownBodyFeatures()
                self.selectedImage.image = UIImage(named: "who-is")
                self.userProtrait.image = UIImage(named: "who-is")
                self.selectedUser = nil
                self.selectedImageID = nil
                self.selectedFeature = nil
                self.nameLabel.text = "No user chosen"
            }
        }
    }
    
    
    @IBAction func assignBtnClicked(_ sender: Any) {
        let userID = (selectedUser?.user_id)!
        let bodyfeature = self.selectedFeature
        let matchTable = self.generateMatchTable(userID:userID, bodyfeature: bodyfeature!)
        self.checkAndUpdateMatchTable(userID: userID, bodyfeature: bodyfeature!, matchTable: matchTable)
    }
    
    
    func generateMatchTable(userID: Int, bodyfeature: BodyFeature) -> [String:Any]{
        let height = bodyfeature.height!
        let weight = bodyfeature.weight!
        let matchTable = ["userID": userID,
                    "height": height,
                    "weight": weight] as [String : Any]
        return matchTable
    }
    
    
    func addOneBodyFeatureToUser(userID:Int, bodyfeature: BodyFeature){
        let raspberryID = person?.raspberryID
        let key = ref.child("RaspberryRepository").child(raspberryID!).child("member").child("\(userID)").child("data").childByAutoId().key
        let date = bodyfeature.dateTime!
        let photo = bodyfeature.photo!
        let height = bodyfeature.height!
        let weight = bodyfeature.weight!
        let oldPhotoID = bodyfeature.photoID!
        let newPhotoID = "\(userID)-\(oldPhotoID.split(separator: "-").last!)"
        let post = ["created_date": date,
                    "photo": photo,
                    "height": height,
                    "wight": weight,
                    "photoID": newPhotoID,
                    "userID": userID] as [String : Any]
        let userDataUpdate = ["/\(key!)": post]
        ref.child("RaspberryRepository").child(raspberryID!).child("member").child("\(userID)").child("data").updateChildValues(userDataUpdate)
        self.deleteUnknownImage(imageID: (self.selectedFeature?.photoID)!)
        self.showMessage("Submitt to family GIF repository.", "Suceess!")
    }
    
    func checkAndUpdateMatchTable(userID: Int, bodyfeature:BodyFeature, matchTable:[String:Any]){
        let raspberryID = person!.raspberryID
        ref.child("RaspberryRepository").child(raspberryID!).child("match_table").queryOrdered(byChild: "userID").queryEqual(toValue: userID).observeSingleEvent(of: .value) { (snapShot) in
            print ("\(snapShot.children.allObjects.count) match table item found in friebase")
            if let items = snapShot.value as? [String: AnyObject]{
                print ("----- user found in match table")
            }else{
                print ("----- user found in match table")
                self.createOneMatchTableToFirebase(matchTable: matchTable)
            }
                self.addOneBodyFeatureToUser(userID: userID,bodyfeature: bodyfeature)
        }
    }
    
    
    func createOneMatchTableToFirebase(matchTable:[String:Any]){
        let raspberryID = person?.raspberryID
        let key = ref.child("RaspberryRepository").child(raspberryID!).child("match_table").childByAutoId().key
        let post = matchTable
        let metchTableUpdate = ["/\(key!)": post]
        ref.child("RaspberryRepository").child(raspberryID!).child("match_table").updateChildValues(metchTableUpdate)
        self.showMessage("Submitt to family GIF repository.", "Suceess!")
        
    }
    
    
    func getAllUnknownBodyFeatures(){
        self.unknownFeatureList = []
        let raspberryID = person?.raspberryID
        ref.child("RaspberryRepository").child(raspberryID!).child("unknown_photo").queryOrdered(byChild: "photoID").observeSingleEvent(of: .value) { (snapShot) in
            print ("searching unknown features in 'data' document in firebase")
            print ("\(snapShot.children.allObjects.count)")
            if let items = snapShot.value as? [String: AnyObject]{
                for oneData in items{
                    let date = oneData.value["created_date"] as! Double
                    let photo = oneData.value["photo"] as! String
                    let height = oneData.value["height"] as! Double
                    let weight = oneData.value["wight"] as! Double
                    let photoID = oneData.value["photoID"] as! String
                    let id = oneData.value["userID"] as! Int
                    let bodyFeature = BodyFeature(user_id: id, dateTime: date, height: height, weight: weight, photo: photo, photoID: photoID)
                    self.unknownFeatureList.append(bodyFeature)
                }
            }
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            self.unknownCollection.reloadData()
        }
    }
    


    // set activity handler
    func setupActivityHandler()
    {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }

    // set selected user values
    func setSelectedUser(user: Person) {
        self.selectedUser = user
        self.nameLabel.text = user.name!
        let photoData = user.portrait!
        let imageData = NSData(base64Encoded: photoData, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        self.userProtrait.image = UIImage(data: imageData! as Data)
        print ("user: \(user.name!) is chosen")
    }
    

    func showMessage(_ message: String, _ title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
 
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         if segue.identifier == "assignUserSegue"{
            let controller = segue.destination as! FamilyListTableViewController
            controller.person = person
            controller.chooseModel = true
            controller.userSelectingDelegate = self
         }
     }

}
