//
//  GIFCollectionViewController.swift
//  A3.b
//
//  Created by 张冬霖 on 2018/11/2.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit


class GIFCollectionViewController: UICollectionViewController {

    let reuseIdentifier = "gifCollectionCell"
    let fileManager = FileManager.default

    var person:Person?
    var raspberryID:String?
    
    var localGIFList:[String] = []
    var firebaseGIFList:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.backgroundView = UIImageView(image: UIImage(named: "background"))
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.localGIFList = self.getAllStoredGifName()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.localGIFList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GIFCollectionViewCell
        cell.backgroundColor = .clear
        // Configure the cell
        let fileName = self.localGIFList[indexPath.row]
        let timeInterval = Double(fileName.split(separator: "-")[1])
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: Date(timeIntervalSince1970: timeInterval!))
        cell.gifImage.image = self.getGIFFromLocalStorage(imageID: fileName)
        cell.gifDateLabel.text = "\(dateString)"
        return cell
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
                    if file.contains("."){
                        let fileExtension = file.split(separator: ".")[1]
                        if fileExtension == "gif"{
                            if fileIdentifier == userIdentifier{
                                print ("-- user gif file found: \(file)")
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
        let fileName = "\(imageID).gif"
        let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let gifURL = documentsDirectoryPath.appending("/\(fileName)")
        print (URL(fileURLWithPath: gifURL).absoluteString)
        let gifViewImage = UIImage.gifImageWithURL(URL(fileURLWithPath: gifURL).absoluteString)
        return gifViewImage!
    }
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
