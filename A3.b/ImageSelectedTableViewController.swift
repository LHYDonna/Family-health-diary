//
//  ImageSelectedTableViewController.swift
//  A3.b
//
//  Created by 张冬霖 on 2018/10/30.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import ImageIO
import MobileCoreServices

protocol ImageTableViewDelegate {
    func reloadTable()
}

class ImageSelectedTableViewController: UITableViewController, ImageTableViewDelegate {

    var storedImagesList:[String]?
    var bodyFeatures:[BodyFeature]?
    var selectedImagesDelegate:SelectedImagesDelegate?
    
    let SECTION_ITEM = 0
    let SECTION_COUNT = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIImageView(image: UIImage.gif(name: "beach-gif"))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == SECTION_COUNT)
        {
            return 1
        }else{
            return (selectedImagesDelegate?.getSelectedImages().count)!
        }
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var reuseIdentifier = "imageTableViewCell"
        if indexPath.section == SECTION_COUNT {
            reuseIdentifier = "countCell"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = .clear
        if indexPath.section == SECTION_ITEM {
            let imageCell = cell as! ImageTableViewCell
            let bodyFeature: BodyFeature = (self.selectedImagesDelegate?.getBodyFeature(index: indexPath.row))!
            imageCell.bodyImageView.image = self.getImageFromLocalStorage(imageID: bodyFeature.photoID!)
            imageCell.heightLabel.text = "\(Double(round(100*bodyFeature.height!)/100)) cm"
            imageCell.weightLabel.text = "\(Double(round(100*bodyFeature.weight!)/100)) Kg"
            imageCell.bodyImageView.layer.masksToBounds = true
            imageCell.bodyImageView.layer.borderWidth = 1.5
            imageCell.bodyImageView.layer.borderColor = UIColor.green.cgColor
            imageCell.bodyImageView.layer.cornerRadius = imageCell.bodyImageView.bounds.width / 7
            let timeInterval = Double(bodyFeature.dateTime!)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = formatter.string(from: Date(timeIntervalSince1970: timeInterval))
            imageCell.dataLabel.text = "\(dateString)"
        }else{
            cell.textLabel?.text = "\((selectedImagesDelegate?.getSelectedImages().count)!) Images Selected"
        }
        
        return cell
     }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the specified item to be editable.
         return true
     }
 
    
    
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
            // Delete the row from the data source
            selectedImagesDelegate?.removeImage(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
         }
        tableView.reloadData()
        self.selectedImagesDelegate?.generateAnimationFromSelectedImages()
     }
    
    
    
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        self.selectedImagesDelegate?.moveImage(fromIndex: fromIndexPath.row, toIndex: to.row)
        tableView.reloadData()
        self.selectedImagesDelegate?.generateAnimationFromSelectedImages()
     }
     
    
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
     }
    
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
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageGallery"{
            let controller = segue.destination as! ImageCollectionViewController
            controller.storedImagesList = self.storedImagesList
            controller.selectedImagesDelegate = self.selectedImagesDelegate
            controller.imageTableDelegate = self
        }
    }

}
