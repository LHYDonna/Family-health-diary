//
//  FamilyReportViewController.swift
//  A3.b
//
//  Created by Hongyu Lin on 3/11/18.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit

class FamilyReportViewController: UITabBarController {

    var person: Person?
    
    // set tab view controller
    // give ndavigations based on the tab users choosed
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let viewControllers = viewControllers else{
            return
        }
        
        for viewController in viewControllers{
            if let ReportBMIViewController = viewController as? ReportBMIViewController{
                ReportBMIViewController.person = person
            }
            if let reportHealthViewController = viewController as? ReportHealthViewContoller{
                reportHealthViewController.person = person
            }
            if let familyGIFGalleryViewController = viewController as? FamilyGIFGalleryViewController{
                familyGIFGalleryViewController.person = person
                familyGIFGalleryViewController.raspberryID = (person?.raspberryID)!
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
