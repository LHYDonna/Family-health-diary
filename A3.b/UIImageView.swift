//
//  UIImageView.swift
//  A3.b
//
//  Created by Hongyu Lin on 3/11/18.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit

extension UIImageView{
    
    func roundedImage() {
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
}
