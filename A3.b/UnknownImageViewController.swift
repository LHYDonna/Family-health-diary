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
    var ref = Database.database().reference()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var unknownImageList:[String] = []
    var unknownUIImageList:[UIImage] = []
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var unknownCollection: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var background: UIImageView!
    
    var person:Person?
    var raspberryID:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedImage.image = UIImage(named: "who-is")
        self.getUnknownImageFromFirebase()
        self.getAllUnknownUIImage()
        self.setupActivityHandler()
        // Do any additional setup after loading the view.
        self.background.image =  UIImage.gif(name: "beach-gif")
        background.contentMode = .scaleToFill
        self.background.layer.zPosition = -1
        self.unknownCollection.backgroundColor = .clear

    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.unknownImageList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "unknownImageCollectionCell", for: indexPath) as! ImageCollectionViewCell
        print (indexPath.row)
        // Configure the cell
        cell.imageView.image = self.unknownUIImageList[indexPath.row]
        cell.imageView.layer.masksToBounds = true
        cell.imageView.layer.borderWidth = 2.5
        cell.imageView.layer.borderColor = UIColor.green.cgColor
        cell.imageView.layer.cornerRadius = cell.imageView.bounds.width / 7
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage.image = self.unknownUIImageList[indexPath.row]
        self.selectedImageID = self.unknownImageList[indexPath.row]
    }
    
    
    @IBAction func assignBtnClicked(_ sender: Any) {
        let userID = (selectedUser?.user_id)!
        let checkResult = self.checkMatchTable(userID: userID)
        let bodyfeature = self.getOneBodyFeatureByImageID(imageID: self.selectedImageID!)
        if checkResult {
            self.addOneBodyFeatureToUser(userID:userID,bodyfeature: bodyfeature!)
        }else{
            let matchTable = self.generateMatchTable(userID:userID, bodyfeature: bodyfeature!)
            self.createOneMatchTableToFirebase(matchTable: matchTable)
            self.addOneBodyFeatureToUser(userID: userID,bodyfeature: bodyfeature!)
        }
    }
    
    func generateMatchTable(userID: Int, bodyfeature: BodyFeature) -> [String:Any]{
        let height = bodyfeature.height!
        let weight = bodyfeature.weight!
        let matchTable = ["height": userID,
                    "weight": height,
                    "userID": weight] as [String : Any]
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
                    "weight": height,
                    "userID": userID] as [String : Any]
        let userDataUpdate = ["/\(key!)": post]
        ref.child("RaspberryRepository").child(raspberryID!).child("member").child("\(userID)").child("data").child("/\(key!)").updateChildValues(userDataUpdate)
        
        self.showMessage("Submitt to family GIF repository.", "Suceess!")
    }
    
    func checkMatchTable(userID: Int) -> Bool{
        var result:Bool = false
        var matchTableUserIDList:[String] = []
        let raspberryID = person!.raspberryID
        ref.child("RaspberryRepository").child(raspberryID!).child("match_table").queryOrdered(byChild: "userID").observeSingleEvent(of: .value) { (snapShot) in
            print ("\(snapShot.children.allObjects.count) match table item found in friebase")
            if let items = snapShot.value as? [String: AnyObject]{
                for item in items{
                    let userIDGet = item.value["userID"] as! String
                    matchTableUserIDList.append(userIDGet)
                }
            }
            if matchTableUserIDList.contains(String(userID)) {
                result = true
            }else{
                result = false
            }
        }
        return result
    }
    
    
    func createOneMatchTableToFirebase(matchTable:[String:Any]){
        let raspberryID = person?.raspberryID
        let key = ref.child("RaspberryRepository").child(raspberryID!).child("match_table").childByAutoId().key
        let post = matchTable
        let metchTableUpdate = ["/\(key!)": post]
        ref.child("RaspberryRepository").child(raspberryID!).child("match_table").child("/\(key!)").updateChildValues(metchTableUpdate)
        self.showMessage("Submitt to family GIF repository.", "Suceess!")
        
    }
    
    
    func getUnknownImageFromFirebase(){
        self.unknownImageList = []
        let raspberryID = person!.raspberryID
        ref.child("RaspberryRepository").child(raspberryID!).child("unknown_photo").queryOrdered(byChild: "created_date").observeSingleEvent(of: .value) { (snapShot) in
            print ("\(snapShot.children.allObjects.count) unknown images found in friebase")
            if let items = snapShot.value as? [String: AnyObject]{
                for item in items{
                    print("=== Geting image data with id: \(item.value["photoID"]!!) ===")
                    let photoID = item.value["photoID"] as! String
                    //let imageData = NSData(base64Encoded: photoData, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
                    //let oneImage = UIImage(data: imageData! as Data)
                    self.unknownImageList.append(photoID)
                }
            }
            
        }
    }
    
    func getAllUnknownUIImage(){
       let raspberryID = person?.raspberryID
        ref.child("RaspberryRepository").child(raspberryID!).child("unknown_photo").queryOrdered(byChild: "created_date").observeSingleEvent(of: .value) { (snapShot) in
            print ("\(snapShot.children.allObjects.count) unknown images found in friebase")
            if let items = snapShot.value as? [String: AnyObject]{
                for item in items{
                    print("=== Geting image data with id: \(item.value["photoID"]!!) ===")
                    let photoID = item.value["photoID"] as! String
                    let photoData = item.value["photo"] as! String
                    let imageData = NSData(base64Encoded: photoData, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
                    let oneImage = UIImage(data: imageData! as Data)
                    self.unknownUIImageList.append(oneImage!)
                }
            }
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            self.unknownCollection.reloadData()
        }
        
    }
    
    func getOneBodyFeatureByImageID(imageID: String) -> BodyFeature?{
        var result:BodyFeature? = nil
        let raspberryID = person?.raspberryID
        ref.child("RaspberryRepository").child(raspberryID!).child("unknow").queryOrdered(byChild: "photoID").queryEqual(toValue: imageID).observeSingleEvent(of: .value) { (snapShot) in
            print ("searching \(imageID) in 'data' document in firebase")
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
                    result = bodyFeature
                }
            }
        }
        return result
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

    func setSelectedUser(user: Person) {
        self.selectedUser = user
        self.nameLabel.text = user.name!
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
