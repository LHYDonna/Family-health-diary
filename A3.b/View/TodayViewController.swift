//
//  TodayViewController.swift
//  A3.b
//
//  Created by Hongyu Lin on 14/10/18.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit
import Firebase

class TodayViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var portraitImage: UIImageView!
    @IBOutlet weak var todayImage: UIImageView!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var background: UIImageView!
    
    var showPersonDelegate: ManagePersonProtocol?
    var person: Person?
    
    // set heightView and weightView Border
    override func viewDidLoad() {
        super.viewDidLoad()
        showData()
        heightView.layer.borderWidth = 2
        heightView.layer.borderColor = UIColor.cyan.cgColor
        heightView.layer.cornerRadius = heightView.bounds.width/7
        weightView.layer.borderWidth = 2
        weightView.layer.borderColor = UIColor.cyan.cgColor
        weightView.layer.cornerRadius = weightView.bounds.width/7
        // Do any additional setup after loading the view.
        
        self.background.image =  UIImage.gif(name: "beach-gif")
        background.contentMode = .scaleToFill
        self.background.layer.zPosition = -1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // get data to display
    func showData(){
        nameLabel.text = person?.name
        let todayFeature = person?.data.last
        heightLabel.text = "\(String(describing: Double(round(todayFeature!.height! * 100) / 100)))"
        weightLabel.text = "\(String(describing: todayFeature!.weight!))"
        let timeGap = getPhotoTimeGap()
        if (timeGap <= 1.0){
            let formatter = DateFormatter()
            formatter.dateFormat = "HH24:MM"
            dateLabel.text = formatter.string(from: Date(timeIntervalSince1970: (person?.data.first?.dateTime!)!))
        }
        if (timeGap <= 7.0){
            dateLabel.text = "Took within 7 days"
        }
        if(timeGap <= 14.0){
            dateLabel.text = "Took one week ago"
        }
        else{
            let formatter = DateFormatter()
            formatter.dateFormat = "DD/MM/YYYY"
            dateLabel.text = formatter.string(from: Date(timeIntervalSince1970: (person?.data.first?.dateTime!)!))
        }
        showPortrait()
        showPhoto()
    }
    
    // get recent photo from firebase
    func showPhoto(){
        let ref = Database.database().reference()
        ref.child("RaspberryRepository").child((person!.raspberryID)!).child("member").child("\(String(describing: person!.user_id!))").child("data").queryOrdered(byChild: "created_date").queryLimited(toFirst: 1).observeSingleEvent(of: .value) { (snapShot) in
            if let items = snapShot.value as? [String: AnyObject]{
                for item in items{
                    let string = item.value["photo"] as? String
                    let imageData = NSData(base64Encoded: string!, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
                    self.todayImage.image = UIImage(data: imageData! as Data)!

                }
            }
        }
    }

    // get portriat data and convert it to image from person object
    func showPortrait(){
        var string = person?.portrait!
        if (string!.elementsEqual("Default")){
            portraitImage.image = UIImage.init(named: "default")
        }
        else{
            if (string!.first == "b"){
                string!.remove(at: (string?.startIndex)!)
            }
            let imageData = NSData(base64Encoded: string!, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
            portraitImage.image = UIImage(data: imageData! as Data)!
            portraitImage.roundedImage()
        }
    }
    
    // get recent photo taken time from person object
    func getPhotoTimeGap() -> Double{
        let currentInterval = Date().timeIntervalSince1970
        let timeGap = (currentInterval - (person?.data.first?.dateTime)!)/1000/60/60/24
        return timeGap
    }
    
}
