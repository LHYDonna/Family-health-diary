//
//  ImageProcessingHomeViewController.swift
//  A3.b
//
//  Created by 张冬霖 on 2018/10/30.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit
import Firebase


//protocol ImageProcessingHomeDelegate {
//    func searchImage(imageID: String) -> UIImage
//    func addImage(imageID: String) -> UIImage
//    func removeImage(imageID: String) -> UIImage
//
//}

class ImageProcessingHomeViewController: UIViewController {
    
    var imageGoingToShow:[String:UIImage] = [String:UIImage]()
    var bodyFeatures:[BodyFeature] = []
    var ref = Database.database().reference()
    let fileManager = FileManager.default
    
    var person:Person?
    var raspberryID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func aa(_ sender: Any) {
        self.bodyFeatures = getAllBodyFeaturesWithoutImageData()
        getAllStoredImageName()
    }
    
    func checkAndRestoreUserFiles(bodyFeatures: [BodyFeature], userStoredFiles: [String]) {
        let userStoredFiles = getAllStoredImageName()
        self.bodyFeatures = getAllBodyFeaturesWithoutImageData()
        for oneFeature in self.bodyFeatures{
            let photoID = oneFeature.photoID
            if
        }
    }
    
    func getAllStoredImageName() -> [String]{
        print ("====== geting storing picture from phone")
        let documentURL = fileManager.urls(for:.documentDirectory,in:.userDomainMask).first!
        let documentPath = documentURL.path
        let userIdentifier = (person?.email)!
        var userStoredFiles:[String] = []
        do{
            let allStoredFiles = try fileManager.contentsOfDirectory(atPath: "\(documentPath)") as [String]
            if allStoredFiles.count != 0 {
                for file in allStoredFiles{
                    print (file)
                    let fileIdentifier = file.split(separator: "-")[0]
                    if fileIdentifier == userIdentifier{
                        print ("-- user file found")
                        userStoredFiles.append(file)
                    }else{
                        print ("-- invalid file")
                    }
                }
            }
        } catch {
            print ("!!! error !!! -- when fileter images")
        }
        return userStoredFiles
    }
//
//    func getImageFromFirebase(imageID:String)->UIImage{
//        
//    }
    
    func getAllBodyFeaturesWithoutImageData() -> [BodyFeature]{
        var bodyFeaturesGot:[BodyFeature] = []
        let userID = (person!.user_id)!
    ref.child("RaspberryRepository").child(raspberryID!).child("member").child(String(userID)).child("data").queryOrdered(byChild: "created_date").observeSingleEvent(of: .value) { (snapShot) in
            if let items = snapShot.value as? [String: AnyObject]{
                for item in items{
                    print("=========geting one data========")
                    var bodyFeature: BodyFeature?
                    print("created_date is: \(item.value["create_date"])")
                    let date = item.value["created_date"] as! Double
                    //let photo = item.value["photo"] as! String
                    let photo = "default"
                    let height = item.value["height"] as! Double
                    let weight = item.value["wight"] as! Double
                    let photoID = item.value["photoID"] as! Int
                    let id = item.value["userID"] as! Int
                    bodyFeature = BodyFeature(user_id: id, dateTime: date, height: height, weight: weight, photo: photo, photoID: photoID)
                    bodyFeaturesGot.append(bodyFeature!)
                    print("=========got one feature========")
                }
                print ("=========features size: \(bodyFeaturesGot.count)")
            }
        }
        return bodyFeaturesGot
    }
    
//    func loadImageRepository(parameters) -> return type {
//        function body
//    }
//
    


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
