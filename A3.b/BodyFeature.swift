//
//  BodyFeature.swift
//  A3.b
//
//  Created by Hongyu Lin on 14/10/18.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit

class BodyFeature: NSObject {
    var user_id: Int?
    var dateTime: Double?
    var height: Double?
    var weight: Double?
    var photo: String?
    var photoID: Int
    
    init(user_id: Int?, dateTime: Double?, height: Double?, weight: Double?, photo: String?,photoID: Int){
        self.user_id = user_id;
        self.dateTime = dateTime
        self.height = height
        self.weight = weight
        self.photo = photo
        self.photoID = photoID
    }
    
    override init(){
        self.user_id = 0;
        self.dateTime = 0
        self.height = 0
        self.weight = 0
        self.photo = "default"
        self.photoID = 0
    }
    
    func toString(){
        print("user_id", user_id as Any)
        print("dateTime", dateTime as Any)
        print("height", height as Any)
        print("weight", weight as Any)
        print("photo", photo as Any)
        print("photoID", photoID as Any)
    }
}
