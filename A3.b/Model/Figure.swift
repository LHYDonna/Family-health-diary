//
//  Figure.swift
//  A3.b
//
//  Created by Hongyu Lin on 3/11/18.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit

class Figure: NSObject {
    var height: Double?
    var weight: Double?
    var age: Int
    var bwi: Double?
    var name: String?
    var pic: String?
    var grade: Double?
    
    init(_ height: Double?,_ weight: Double?,_ age: Int, _ bwi: Double?,_ name: String?, _ pic: String?,_ grade: Double? = 0.0){
        self.height = height
        self.weight = weight
        self.age = age
        self.bwi = bwi
        self.name = name
        self.pic  = pic
        self.grade = grade
    }
}
