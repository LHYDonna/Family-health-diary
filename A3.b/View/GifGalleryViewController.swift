//
//  GifGalleryViewController.swift
//  A3.b
//
//  Created by 张冬霖 on 2018/10/31.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit
import ImageIO
import MobileCoreServices

class GifGalleryViewController: UIViewController {

    @IBOutlet weak var gifView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // show gif
    @IBAction func showGIF(_ sender: Any) {
        let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let gifURL = documentsDirectoryPath.appending("/testGIF.gif")
        print (URL(fileURLWithPath: gifURL).absoluteString)
        //gifView.image = UIImage.gifImageWithURL(URL(fileURLWithPath: gifURL).absoluteString)
        showMessage("kkkk", "kkk")
        
    }
    
    // show messages function
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
