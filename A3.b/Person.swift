//
//  Person.swift
//  A3.b
//
//  Created by Hongyu Lin on 14/10/18.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit

class Person: NSObject {
    var user_id: Int?
    var email: String?
    var password: String?
    var name: String?
    var dob: Double?
    var portrait: String?
    var gender: String?
    var registerDate: Double?
    var height: String?
    var weight: String?
    var data: [BodyFeature]
    
    init(user_id: Int?, email: String?, name: String?, password: String?, dob: Double?, portrait: String?, gender: String, registerDate: Double?, height: String?, weight: String?,data: [BodyFeature]){
        self.user_id = user_id
        self.email = email
        self.password = password
        self.name = name
        self.dob = dob
        self.portrait = portrait
        self.gender = gender
        self.registerDate = registerDate
        self.height = height
        self.weight = weight
        self.data = data
    }
    
    func toString(){
        print("person_id", user_id as Any)
        print("email", email as Any)
        print("password", password as Any)
        print("name", name as Any)
        print("date of birth", dob as Any)
        print("portrait", portrait as Any)
        print("gender", gender as Any)
        print("registerDate", registerDate as Any)
        print("height", height as Any)
        print("weight", weight as Any)
        for oneData in data{
            oneData.toString()
        }
        
    }
}
