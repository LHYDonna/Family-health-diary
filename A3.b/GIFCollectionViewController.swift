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
        self.collectionView!.backgroundView = UIImageView(image: UIImage.gif(name: "beach-gif"))
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.localGIFList = self.getAllStoredGifName()
    }

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

}
