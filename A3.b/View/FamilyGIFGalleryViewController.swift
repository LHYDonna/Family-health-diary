//
//  FamilyGIFGalleryViewController.swift
//  A3.b
//
//  Created by 张冬霖 on 2018/11/4.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit
import Firebase
import ImageIO
import MobileCoreServices

class FamilyGIFGalleryViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {

    
    let reuseIdentifier = "familyGIFCell"
    let fileManager = FileManager.default
    var ref = Database.database().reference()
    var result:String = "unfinish"
    
    @IBOutlet weak var collectionView: UICollectionView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var person:Person?
    var raspberryID:String?
    
    var firebaseGIFList:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAllSharedGifFromFirebase()
        self.setupActivityHandler()
        self.collectionView.backgroundColor = .clear
        // Do any additional setup after loading the view.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.firebaseGIFList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GIFCollectionViewCell
        
        // Configure the cell
        let gifString = self.firebaseGIFList[indexPath.row]
        cell.gifImage.image = UIImage.gif(data: NSData(base64Encoded: gifString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)! as Data)
        cell.gifImage.layer.masksToBounds = true
        cell.gifImage.layer.borderWidth = 2.5
        cell.gifImage.layer.borderColor = UIColor.green.cgColor
        cell.gifImage.layer.cornerRadius = cell.gifImage.bounds.width / 7
        
        return cell
    }
    
    
    func getAllSharedGifFromFirebase(){
        self.firebaseGIFList = []
        ref.child("RaspberryRepository").child(raspberryID!).child("shared_gif").queryOrderedByKey().observeSingleEvent(of: .value) { (snapShot) in
            print ("\(snapShot.children.allObjects.count)")
            print ("==== geting shared gifs from firebase0 ====")
            if let items = snapShot.value as? [String: AnyObject]{
                print ("==== geting shared gifs from firebase1 ====")
                for item in items{
                    print("=========geting one gif========")
                    let photoData = item.value["gif_data"] as! String
                    self.firebaseGIFList.append(photoData)
                }
            }
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            if (self.firebaseGIFList.count == 0){
                self.showMessage("No gif has been shared...", "Ah oh!")
            }
        }

    }

    // show messages function
    func showMessage(_ message: String, _ title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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

    
    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        
     }
    
}
