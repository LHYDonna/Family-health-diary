//
//  ImageProcessingHomeViewController.swift
//  A3.b
//
//  Created by 张冬霖 on 2018/10/30.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit
import Firebase
import SwiftGifOrigin
import ImageIO
import MobileCoreServices


protocol SelectedImagesDelegate {
    func getBodyFeature(index: Int) -> BodyFeature?
    func addImage(imageID: String)
    func removeImage(index: Int)
    func getSelectedImages() -> [String]
    func moveImage(fromIndex:Int, toIndex:Int)
    func generateAnimationFromSelectedImages()
}

extension UIImage {
    public class func gif(asset: String) -> UIImage? {
        if let asset = NSDataAsset(name: asset) {
            return UIImage.gif(data: asset.data)
        }
        return nil
    }
}

class ImageProcessingHomeViewController: UIViewController, SelectedImagesDelegate{

    @IBOutlet weak var animationView: UIImageView!
    @IBOutlet weak var background: UIImageView!
    
    var imageGoingToShow:[String:UIImage] = [String:UIImage]()
    var bodyFeatures:[BodyFeature] = []
    var storedImageList:[String] = []
    var selectedImages:[String] = []
    var ref = Database.database().reference()
    let fileManager = FileManager.default
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    let ANIMATION_DURATION = 1.0
    
    var person:Person?
    var raspberryID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.background.image =  UIImage(named: "background")
        background.contentMode = .scaleToFill
        self.background.layer.zPosition = -1

        
        animationView.image = UIImage.gif(name: "plant-grow")
        animationView.layer.masksToBounds = true
        animationView.layer.borderWidth = 1.0
        animationView.layer.borderColor = UIColor.black.cgColor
        animationView.layer.cornerRadius = animationView.bounds.width / 5
        
        self.getAllBodyFeaturesWithoutImageData()
        self.setupActivityHandler()
        
    }
   
    func checkAndRestoreUserFiles() {
        //get locally stored images
        self.storedImageList = getAllStoredImageName()
        //compare bodyfeatures and userStoredFiles to find out unstored images
        
        print ("userStoredFiles.count = \(self.storedImageList.count)")
        print ("bodyFeatures.count = \(self.bodyFeatures.count)")
        print ("-------- user Stored Files: --------")
        for id in self.storedImageList {
            print (id)
        }
        
//        var unstoredImages:[String:UIImage] = [String:UIImage]()
        for oneFeature in self.bodyFeatures{
            let photoID = oneFeature.photoID
            print ("--- Checking file: \(photoID!)")
            if self.storedImageList.contains(photoID!){
                print ("File: \(photoID!) already exist" )
            }else{
                print ("saving File: \(photoID!) " )
                getAndSaveUnstoredImageByImageID(imageID: photoID!)
            }
        }
        
        self.storedImageList = getAllStoredImageName()

    }
    
    func getAllStoredImageName() -> [String]{
        print ("====== geting storing picture from phone")
        let documentURL = fileManager.urls(for:.documentDirectory,in:.userDomainMask).first!
        let documentPath = documentURL.path
        let userIdentifier = (String)((person?.user_id)!)
        var userStoredFiles:[String] = []
        do{
            let allStoredFiles = try fileManager.contentsOfDirectory(atPath: "\(documentPath)") as [String]
            if allStoredFiles.count != 0 {
                for file in allStoredFiles{
                    print (file)
                    let fileIdentifier = file.split(separator: "-")[0]
                    if file.contains("."){
                        let fileExtension = file.split(separator: ".")[1]
                        if fileExtension == "png"{
                            if fileIdentifier == userIdentifier{
                                print ("-- user file found: \(file)")
                                userStoredFiles.append(String(file.split(separator: ".")[0]))
                            }else{
                                print ("-- invalid file: \(file)")
                            }
                        }else{
                            print ("-- invalid file: \(file)")
                        }
                    }else{
                        print ("-- invalid file: \(file)")
                    }
                    
                    
                }
            }
        } catch {
            print ("!!! error !!! -- when fileter images")
        }
        return userStoredFiles
    }
    
    func getAndSaveUnstoredImageByImageID(imageID: String){
        let userID = (person!.user_id)!
    ref.child("RaspberryRepository").child(raspberryID!).child("member").child(String(userID)).child("data").queryOrdered(byChild: "photoID").queryEqual(toValue: imageID).observeSingleEvent(of: .value) { (snapShot) in
        print ("searching \(imageID) in 'data' document in firebase")
        print ("\(snapShot.children.allObjects.count)")
        if let items = snapShot.value as? [String: AnyObject]{
            for item in items{
                print("=== Geting image data with id: \(item.value["photoID"]!!) ===")
                let photoData = item.value["photo"] as! String
                let imageData = NSData(base64Encoded: photoData, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
                let oneImage = UIImage(data: imageData! as Data)
                self.saveOneImageToLocal(imageName: imageID, image: oneImage!)
            }
        }
        }
    }
    
    func saveOneImageToLocal(imageName: String, image: UIImage) {
        print ("=== start storing picture to phone")
        let documentURL = fileManager.urls(for:.documentDirectory, in:.userDomainMask).first!
        //let documentPath = documentURL.path
        
        //var alreadyStoredInPhone:Bool = false
        //filter already stored image
        do{
            print ("\(imageName)")
            let filePath = documentURL.appendingPathComponent("\(imageName).png")
            if let imagePNGData = UIImagePNGRepresentation(image) {
                try imagePNGData.write(to: filePath, options: .atomic)
            }
        } catch {
            print ("!!! error when fileter images: \(error)")
        }
        print ("finish storing one picture to phone")
    }
    
    func getAllBodyFeaturesWithoutImageData(){
        self.bodyFeatures = []
        let userID = (person!.user_id)!
    ref.child("RaspberryRepository").child(raspberryID!).child("member").child(String(userID)).child("data").queryOrdered(byChild: "created_date").observeSingleEvent(of: .value) { (snapShot) in
            print ("==== geting bodyFeatures from firebase0 ====")
            if let items = snapShot.value as? [String: AnyObject]{
                print ("==== geting bodyFeatures from firebase1 ====")
                for item in items{
                    print("=========geting one data========")
                    var bodyFeature: BodyFeature?
                    let date = item.value["created_date"] as! Double
                    //let photo = item.value["photo"] as! String
                    let photo = "default"
                    let height = item.value["height"] as! Double
                    let weight = item.value["wight"] as! Double
                    let photoID = item.value["photoID"] as! String
                    let id = item.value["userID"] as! Int
                    bodyFeature = BodyFeature(user_id: id, dateTime: date, height: height, weight: weight, photo: photo, photoID: photoID)
                    self.bodyFeatures.append(bodyFeature!)
                    print("=========got one feature========")
                }
                print ("=========features size: \(self.bodyFeatures.count)")
            }
        self.checkAndRestoreUserFiles()
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    // implement delegate method
    func getBodyFeature(index: Int) -> BodyFeature? {
        for feature in self.bodyFeatures{
            if feature.photoID == selectedImages[index]{
                return feature
            }
        }
        return nil
    }
    
    func addImage(imageID: String) {
        selectedImages.append(imageID)
    }
    
//    func removeImage(imageID: String) -> Int? {
//        var index:Int
//        for i in 0..<selectedImages.count{
//            if selectedImages[i] == imageID{
//                selectedImages.remove(at: i)
//                index = i
//            }
//        }
//        return index
//    }
    
    func removeImage(index: Int) {
         selectedImages.remove(at: index)
    }

    
    func getSelectedImages() -> [String] {
        return self.selectedImages
    }
    
    func moveImage(fromIndex: Int, toIndex: Int) {
        let changedImage = selectedImages.remove(at: fromIndex)
        selectedImages.insert(changedImage, at: toIndex)
    }

    func generateAnimationFromSelectedImages() {
        var images:[UIImage] = []
        for imageID in selectedImages{
            images.append(getImageFromLocalStorage(imageID: imageID))
        }
        animationView.animationImages = images
        animationView.animationDuration = self.ANIMATION_DURATION
        animationView.animationRepeatCount = 0
        animationView.startAnimating()
        print ("=== finished generating gif")
    }
    
    // get image from local storage
    func getImageFromLocalStorage(imageID: String) -> UIImage{
        let fileName = "\(imageID).png"
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        var image: UIImage?
        if let pathComponent = url.appendingPathComponent(fileName) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            let fileData = fileManager.contents(atPath: filePath)
            image = UIImage(data: fileData!)
        }
        return image!
    }
    
    // generate gif and save it to local storage
    func generateAndSaveGifWithExtension(photos: [UIImage], filename: String) -> Bool {
        let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let path = documentsDirectoryPath.appending("/\(filename).gif")
        print ("\(path)")
        let fileProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0]]
        let gifProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: self.ANIMATION_DURATION]]
        let cfURL = URL(fileURLWithPath: path) as CFURL
        if let destination = CGImageDestinationCreateWithURL(cfURL, kUTTypeGIF, photos.count, nil) {
            CGImageDestinationSetProperties(destination, fileProperties as CFDictionary?)
            for photo in photos {
                CGImageDestinationAddImage(destination, photo.cgImage!, gifProperties as CFDictionary?)
            }
            return CGImageDestinationFinalize(destination)
        }
        return false
    }
    
    // save images to firebase
    @IBAction func saveBtnClicked(_ sender: Any) {
        if selectedImages.count <= 1{
            self.showMessage("Please selected at least two images.", "Failed...")
        }else{
            var images:[UIImage] = []
            for imageID in selectedImages{
                images.append(getImageFromLocalStorage(imageID: imageID))
            }
            let timeInterval = Int(Date().timeIntervalSince1970)
            let fileName = "\((person?.user_id)!)-\(timeInterval)"
            if self.generateAndSaveGifWithExtension(photos:images, filename:"\(fileName)"){
                self.showMessage("Gif file is successfully generated. Check in your GIF gallery.", "Success!")
            }else{
                self.showMessage("Failed to generate Gif file, please try again.", "Failed...")
            }
            self.selectedImages = []
            animationView.stopAnimating()
            animationView.image = UIImage.gif(name: "plant-grow")
            animationView.layer.masksToBounds = true
            animationView.layer.borderWidth = 1.5
            animationView.layer.borderColor = UIColor.green.cgColor
            animationView.layer.cornerRadius = animationView.bounds.width / 5
        }
    }
    
    // show message function
    func showMessage(_ message: String, _ title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
    
    // navigate to image selected view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedImages"{
            let controller = segue.destination as! ImageSelectedTableViewController
            controller.storedImagesList = self.getAllStoredImageName()
            controller.bodyFeatures = self.bodyFeatures
            controller.selectedImagesDelegate = self
        }
    }
    

}


