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
    var ref = Database.database().reference()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var unknownImageList:[UIImage] = []
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
    
    // set image cell to the collectionview
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "unknownImageCollectionCell", for: indexPath) as! ImageCollectionViewCell
        print (indexPath.row)
        // Configure the cell
        cell.imageView.image = self.unknownImageList[indexPath.row]
        cell.imageView.layer.masksToBounds = true
        cell.imageView.layer.borderWidth = 2.5
        cell.imageView.layer.borderColor = UIColor.green.cgColor
        cell.imageView.layer.cornerRadius = cell.imageView.bounds.width / 7
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage.image = self.unknownImageList[indexPath.row]
    }
    
    
    @IBAction func assignBtnClicked(_ sender: Any) {
        
    }
    
    // get unknown images from firebase
    func getUnknownImageFromFirebase(){
        let raspberryID = person!.raspberryID
        ref.child("RaspberryRepository").child(raspberryID!).child("unknown_photo").queryOrdered(byChild: "created_date").observeSingleEvent(of: .value) { (snapShot) in
            print ("\(snapShot.children.allObjects.count) unknown images found in friebase")
            if let items = snapShot.value as? [String: AnyObject]{
                for item in items{
                    print("=== Geting image data with id: \(item.value["photoID"]!!) ===")
                    let photoData = item.value["photo"] as! String
                    let imageData = NSData(base64Encoded: photoData, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
                    let oneImage = UIImage(data: imageData! as Data)
                    self.unknownImageList.append(oneImage!)
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
        print ("user: \(user.name!) is chosen")
    }
    
    // navigate to familyList tableView with person data
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
