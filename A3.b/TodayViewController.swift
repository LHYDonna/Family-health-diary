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
    
    var showPersonDelegate: ManagePersonProtocol?
    var person: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showData(){
        nameLabel.text = person?.name
        let todayFeature = person?.data.last
        heightLabel.text = "\(String(describing: todayFeature!.height!))"
        weightLabel.text = "\(String(describing: todayFeature!.weight!))"
        
        
        let string = todayFeature?.photo!
        let imageData = NSData(base64Encoded: string!, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        todayImage.image = UIImage(data: imageData! as Data)!
        
        showPortrait()
    }
    
    func showPhoto(){
        let ref = Database.database().reference()
        ref.child("RaspberryRepository").child((person!.raspberryID)!).child("member").child("\(person?.user_id)").child("data").queryOrdered(byChild: "created_date").queryLimited(toFirst: 1).observeSingleEvent(of: .value) { (snapShot) in
            if let items = snapShot.value as? [String: AnyObject]{
                for item in items{
                    
                }
            }
        }
    }

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
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
