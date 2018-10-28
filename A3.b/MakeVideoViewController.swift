//
//  MakeVideoViewController.swift
//  A3.b
//
//  Created by 张冬霖 on 2018/10/27.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit
import Firebase

class MakeVideoViewController: UIViewController {

    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    
    var startDate:Int?
    var endDate:Int?
    
    var ref = Database.database().reference().child("assignment3-2bbc1")
    var person:Person?
    var personDelegate: ManagePersonProtocol?
    
    var handle: DatabaseHandle?
    var timeInterval: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        startDate = Int(startDatePicker.date.timeIntervalSince1970 * 1000)
        endDate = Int(endDatePicker.date.timeIntervalSince1970 * 1000)
    }
    
    
    @IBAction func setStartDate(_ sender: Any) {
        startDate = Int(startDatePicker.date.timeIntervalSince1970 * 1000)
    }
    
    @IBAction func setEndDate(_ sender: Any) {
         endDate = Int(endDatePicker.date.timeIntervalSince1970 * 1000)
    }
    
    @IBAction func viewGif(_ sender: Any) {
        //bodyFeatures = getAllBodyFeaturesBasedOnTimeSelected()
        let bodyFeatures = getAllBodyFeaturesBasedOnTimeSelected()
        //images = generateImagesFromBodyFeatures(bodyFeatures: [BodyFeature])
        let images = generateImagesFromBodyFeatures(bodyFeatures: bodyFeatures)
        //gif = generateGifFromImages(images)
        generateGifFromImages(images:images)
    }
    
    func generateGifFromImages(images: [UIImage]) {
        imageView.animationImages = images
        imageView.animationDuration = 0.5
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
        print ("=== done generate gif")
    }
    
    func generateImagesFromBodyFeatures(bodyFeatures:[BodyFeature]) -> [UIImage] {
        var resultImages:[UIImage] = []
        for oneFeature in bodyFeatures{
            var photoData = oneFeature.photo
//            photoData!.remove(at: (photoData?.startIndex)!)
            let imageData = NSData(base64Encoded: photoData!, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
            let oneImage = UIImage(data: imageData! as Data)!
            resultImages.append(oneImage)
        }
        print ("=== get \(resultImages.count) images")
        return resultImages
    }
    
    func getAllBodyFeaturesBasedOnTimeSelected() -> [BodyFeature] {
        print("=========start geting features========")
        var bodyFeatures: [BodyFeature] = []
////        let userID = (person?.user_id)!   ref.child("raspberry").child("member").child(String(userID)).child("data").queryOrdered(byChild: "created_date").queryLimited(toFirst: 11).observeSingleEvent(of: .value) { (snapShot) in
//        let email = Auth.auth().currentUser?.email
//        print ("email: \(email!)")
//        ref.child("raspberry").child("member").queryOrdered(byChild: "email").queryEqual(toValue: email!).observeSingleEvent(of: .value) { (snapShot) in
//            if let items = snapShot.value as? [String: AnyObject]{
//                print ("======size: \(items.count)")
//                for item in items{
//                    print("=========geting one data========")
//                    if let itemData = item.value["data"] as? [String: AnyObject]{
//                        var bodyFeature: BodyFeature?
//                        for oneData in itemData{
//                            //print(oneData.value["create_date"])
//                            let date = oneData.value["created_date"] as! Double
//                            let photo = oneData.value["photo"] as! String
//                            let height = oneData.value["height"] as! Double
//                            let weight = oneData.value["wight"] as! Double
//                            let photoID = oneData.value["photoID"] as! Int
//                            let id = oneData.value["userID"] as! Int
//                            bodyFeature = BodyFeature(user_id: id, dateTime: date, height: height, weight: weight, photo: photo, photoID: photoID)
//                            bodyFeatures.append(bodyFeature!)
//                            print("=========get one feature========")
//                        }
//                    }
//                }
//            }
//            else{
//                print ("No items")
//            }
//        }
        return (person?.data)!
    }
    
    
    
}
