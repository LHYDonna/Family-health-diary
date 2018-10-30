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
//
//    @IBOutlet weak var startDatePicker: UIDatePicker!
//    @IBOutlet weak var endDatePicker: UIDatePicker!
//    @IBOutlet weak var imageView: UIImageView!
//
//    var startDate:Int?
//    var endDate:Int?
//
//    let fileManager = FileManager.default
//
//    var ref = Database.database().reference()
//    var person:Person?
//    var raspberryID:String?
//    var personDelegate: ManagePersonProtocol?
//    var bodyFeatures: [BodyFeature] = []
//    var imagesDictionary: [String:UIImage] = [String:UIImage]()
//
//    var handle: DatabaseHandle?
//    var timeInterval: Double?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        ref = Database.database().reference()
//        startDate = Int(startDatePicker.date.timeIntervalSince1970 * 1000)
//        endDate = Int(endDatePicker.date.timeIntervalSince1970 * 1000)
//    }
//
//
//    @IBAction func setStartDate(_ sender: Any) {
//        startDate = Int(startDatePicker.date.timeIntervalSince1970 * 1000)
//    }
//
//    @IBAction func setEndDate(_ sender: Any) {
//         endDate = Int(endDatePicker.date.timeIntervalSince1970 * 1000)
//    }
//
//    @IBAction func viewGif(_ sender: Any) {
//        //bodyFeatures = getAllBodyFeaturesBasedOnTimeSelected()
//        getAllBodyFeaturesBasedOnTimeSelected()
//        //images = generateImagesFromBodyFeatures(bodyFeatures: [BodyFeature])
//        //let images = self.generateImagesFromBodyFeatures(bodyFeatures: bodyFeatures)
//        //gif = generateGifFromImages(images)
//        //self.generateGifFromImages(images:images)
//    }
//
//    func generateGifFromImages(imagesDic: [String:UIImage]) {
//        let images = [UIImage](imagesDic.values)
//        imageView.animationImages = images
//        imageView.animationDuration = 0.5
//        imageView.animationRepeatCount = 0
//        imageView.startAnimating()
//        print ("=== done generate gif")
//    }
//
//    func generateImagesFromBodyFeatures(bodyFeatures:[BodyFeature]) {
//        print ("=== get \(bodyFeatures.count) features")
//        for oneFeature in bodyFeatures{
//            let photoData = oneFeature.photo
//            let imageData = NSData(base64Encoded: photoData!, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
//            let oneImage = UIImage(data: imageData! as Data)!
//            self.imagesDictionary.updateValue(oneImage, forKey: String(oneFeature.photoID))
//        }
//        print ("=== make \(self.imagesDictionary.count) images")
//    }
//
//
//    func getAllBodyFeaturesBasedOnTimeSelected() {
//        print("=========start geting features========")
//        //var bodyFeatures: [BodyFeature] = []
//        let userID = (person?.user_id)!
//        ref.child("RaspberryRepository").child(raspberryID!).child("member").child(String(userID)).child("data").queryOrdered(byChild: "created_date").observeSingleEvent(of: .value) { (snapShot) in
//            if let items = snapShot.value as? [String: AnyObject]{
//                print ("======size: \(items.count)")
//                for item in items{
//                    print("=========geting one data========")
//                    var bodyFeature: BodyFeature?
//                    //print(oneData.value["create_date"])
//                    let date = item.value["created_date"] as! Double
//                    let photo = item.value["photo"] as! String
//                    let height = item.value["height"] as! Double
//                    let weight = item.value["wight"] as! Double
//                    let photoID = item.value["photoID"] as! Int
//                    let id = item.value["userID"] as! Int
//                    bodyFeature = BodyFeature(user_id: id, dateTime: date, height: height, weight: weight, photo: photo, photoID: photoID)
//                    self.bodyFeatures.append(bodyFeature!)
//                    print("=========get one feature========")
//                    print ("=========features size: \(self.bodyFeatures.count)")
//                }
//                print ("=========features size: \(self.bodyFeatures.count)")
//                self.generateImagesFromBodyFeatures(bodyFeatures: self.bodyFeatures)
//                self.generateGifFromImages(imagesDic: self.imagesDictionary)
//                self.saveImagesToPhone()
//
//            }
//            }
//    }
//
//
//    func saveImagesToPhone(){
//        print ("start storing picture to phone")
//        let documentURL = fileManager.urls(for:.documentDirectory, in:.userDomainMask).first!
//        let documentPath = documentURL.path
//
//        for oneImage in imagesDictionary {
//            var alreadyStoredInPhone:Bool = false
//            let oneImageID = oneImage.key
//            let oneImageData = oneImage.value
//            //filter already stored image
//            do{
//                let filePath = documentURL.appendingPathComponent("\(oneImageID).png")
//                let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
//                for file in files{
//                    if "\(documentPath)/\(file)" == filePath.path{
//                        alreadyStoredInPhone = true
//                    }
//                }
//                if alreadyStoredInPhone == false{
//                    //store filtered unstored images
//                    do{
//                        if let imagePNGData = UIImagePNGRepresentation(oneImageData) {
//                            try imagePNGData.write(to: filePath, options: .atomic)
//                        }
//                    } catch {
//                        print ("cannot write image")
//                    }
//                }
//            } catch {
//                print ("!!! error when fileter images")
//            }
//        }
//        print ("finish storing picture to phone")
//
//    }
//
//    @IBAction func saveToLibrary(_ sender: AnyObject) {
//        for image in [UIImage](self.imagesDictionary.values) {
//            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
//        }
//    }
//
//    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
//        if let error = error {
//            // we got back an error!
//            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default))
//            present(ac, animated: true)
//        } else {
//
//            let ac = UIAlertController(title: "Saved!", message: "The screenshot has been saved to your photos.", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default))
//            present(ac, animated: true)
//        }
//    }
//
}
