//
//  ImageCollectionViewController.swift
//  A3.b
//
//  Created by 张冬霖 on 2018/10/30.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ImageCollectionViewController: UICollectionViewController {
//
//    private let reuseIdentifier = "imageCell"
//    private let sectionInsets = UIEdgeInsets(top:50.0, left:20.0, bottom:50.0, right:20.0)
//    private let itemsPerRow: CGFloat = 3
//
//    var animalInfoDelegate: AnimalInfoDelegate?
//    var iconNameList = [String]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        iconNameList = [String]()
//        setIconNameList()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//    }
//
//    //initial the icon list, using this can track all the icons saved in assets filefolder
//    func setIconNameList(){
//        self.iconNameList.append("default")
//        self.iconNameList.append("bird")
//        self.iconNameList.append("lion")
//        self.iconNameList.append("cat")
//        self.iconNameList.append("dog")
//        self.iconNameList.append("elephant")
//        self.iconNameList.append("horse")
//        self.iconNameList.append("pig")
//        self.iconNameList.append("rabbit")
//        self.iconNameList.append("reindeer")
//        self.iconNameList.append("rooster")
//        self.iconNameList.append("snake")
//    }
//
//
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return iconNameList.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! IconCollectionViewCell
//        cell.backgroundColor = UIColor.white
//        let animalIcon:String = iconNameList[indexPath.row]
//        cell.imageView.image = UIImage(named:animalIcon.lowercased())
//        return cell
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        animalInfoDelegate?.setIconName(iconNameList[indexPath.row])
//        self.navigationController?.popViewController(animated: true)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
//        let availableWidth = view.frame.width - paddingSpace
//        let widthPerItem = availableWidth / itemsPerRow
//
//        return CGSize(width:widthPerItem, height:widthPerItem)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return sectionInsets.left
//    }
//
    
}
