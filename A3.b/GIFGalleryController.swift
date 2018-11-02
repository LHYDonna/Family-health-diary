//
//  GifGalleryController.swift
//  A3.b
//
//  Created by 张冬霖 on 2018/11/2.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit
import Firebase
import ImageIO
import MobileCoreServices

class GifGalleryController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    let reuseIdentifier = "gifCollectionCell"
    let fileManager = FileManager.default
    var ref = Database.database().reference()

    @IBOutlet weak var selectedGif: UIImageView!
    var selectedGifID:String?
    
    var person:Person?
    var raspberryID:String?
    
    var localGIFList:[String] = []
    var firebaseGIFList:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localGIFList = self.getAllStoredGifName()
        // Do any additional setup after loading the view.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.localGIFList.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GIFCollectionViewCell
        
        // Configure the cell
        let fileName = self.localGIFList[indexPath.row]
        let timeInterval = Double(fileName.split(separator: "-")[1])
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: Date(timeIntervalSince1970: timeInterval!))
        print ("--- generating GIF Cell using file: \(fileName)")
        cell.gifImage.image = self.getGIFFromLocalStorage(imageID: fileName)
        cell.gifDateLabel.text = "\(dateString)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fileName = self.localGIFList[indexPath.row]
        self.selectedGif.image = self.getGIFFromLocalStorage(imageID: fileName)
        self.selectedGifID = fileName
    }
    
    @IBAction func saveToFamilyGalleryBtnClicked(_ sender: Any) {

        if let gifID = self.selectedGifID{
            let created_date = gifID.split(separator: "-")[1]
            let gifImage = (selectedGif.image)!
            let gifData = UIImagePNGRepresentation(gifImage)!
            let gif_data64 = gifData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
            print ("searching \(gifID) in 'data' document in firebase")
            let key = ref.child("RaspberryRepository").child(raspberryID!).child("shared_gif").childByAutoId().key
            let post = ["created_date": created_date,
                        "personID": (person?.user_id)!,
                        "gifID": gifID,
                        "gif_data": gif_data64] as [String : Any]
            let childUpdates = ["/\(key)": post]
            ref.child("RaspberryRepository").child(raspberryID!).child("shared_gif").updateChildValues(childUpdates)
            self.showMessage("Submitt to family GIF repository.", "Suceess!")
        }else{
            self.showMessage("Please select a GIF first.", "Warning")
        }

        
        
    }
    
    
    func getAllStoredGifName() -> [String]{
        print ("====== geting storing GIF from phone")
        let documentURL = fileManager.urls(for:.documentDirectory,in:.userDomainMask).first!
        let documentPath = documentURL.path
        let userIdentifier = (String)((person?.user_id)!)
        var userStoredFiles:[String] = []
        do{
            let allStoredFiles = try fileManager.contentsOfDirectory(atPath: "\(documentPath)") as [String]
            if allStoredFiles.count != 0 {
                for file in allStoredFiles{
                    print ("--- opening file: \(file)")
                    let fileIdentifier = file.split(separator: "-")[0]
                    if file.split(separator: ".").count == 2{
                        let fileExtension = file.split(separator: ".")[1]
                        if fileExtension == "gif"{
                            if fileIdentifier == userIdentifier{
                                print ("-- !!! user gif file found: \(file)")
                                userStoredFiles.append(String(file.split(separator: ".")[0]))
                            }else{
                                print ("-- not a user's file: \(file)")
                            }
                        }else{
                            print ("-- wrong file extension: \(file)")
                        }
                    }else{
                        print ("-- no file extension: \(file)")
                    }
                    
                    
                }
            }
        } catch {
            print ("!!! error !!! -- when fileter GIF")
        }
        return userStoredFiles
    }
    
    
    func getGIFFromLocalStorage(imageID: String) -> UIImage{
        print ("--- generating a gif image!!")
        let fileName = "\(imageID).gif"
        let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let gifURL = documentsDirectoryPath.appending("/\(fileName)")
        print (URL(fileURLWithPath: gifURL).absoluteString)
        let gifViewImage = UIImage.gifImageWithURL(URL(fileURLWithPath: gifURL).absoluteString)
        return gifViewImage!
    }
    
    func showMessage(_ message: String, _ title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
