//
//  ImageCollectionViewController.swift
//  A3.b
//
//  Created by 张冬霖 on 2018/10/30.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit

class ImageCollectionViewController: UICollectionViewController {

    private let reuseIdentifier = "imageCell"
    private let sectionInsets = UIEdgeInsets(top:50.0, left:20.0, bottom:50.0, right:20.0)
    private let itemsPerRow: CGFloat = 2

    var storedImagesList:[String]?
    var selectedImagesDelegate:SelectedImagesDelegate?
    var imageTableDelegate:ImageTableViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storedImagesList!.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        //cell.backgroundColor = UIColor.white
        cell.imageView.image = getImageFromLocalStorage(imageID: storedImagesList![indexPath.row])
        cell.imageView.layer.masksToBounds = true
        cell.imageView.layer.borderWidth = 2.0
        cell.imageView.layer.borderColor = UIColor.green.cgColor
        cell.imageView.layer.cornerRadius = cell.imageView.bounds.width / 7
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImagesDelegate?.addImage(imageID: storedImagesList![indexPath.row])
        self.showMessage("One image is added to the selected list, you can check it in the table list.", "Success!")
        self.imageTableDelegate?.reloadTable()
        self.selectedImagesDelegate?.generateAnimationFromSelectedImages()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width:widthPerItem, height:widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

    func showMessage(_ message: String, _ title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
