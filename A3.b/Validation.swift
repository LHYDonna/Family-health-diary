//
//  Validation.swift
//  A3.b
//
//  Created by Hongyu Lin on 4/11/18.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit

class Validation: NSObject {
    
    required override init() {
    }
    
    // check if name is valid
    // must not be blank
    // must not contain special characters or numbers
    // do not accept space
    // no more than 10 characters
    func checkNameValid(_ newName: String) ->Bool{
        if (checkStringNotBlank(newName) && checkStringLegal(newName) && checkStringLength(newName,10)){
            return true
        }
        return false
    }
    
    // check if raspberryID is valid
    // must not be blank
    // do not accept space
    // no more than 15 characters
    func checkRaspberryIDValid(_ newName: String) ->Bool{
        if (checkStringNotBlank(newName) && checkStringLength(newName,15)){
            return true
        }
        return false
    }
    
    // check string not blank
    func checkStringNotBlank(_ AString: String) ->Bool{
        let chars = AString.trimmingCharacters(in: .whitespacesAndNewlines)
        if (chars != ""){
            return true
        }
        return false
    }
    
    // check string is made of letters only
    func checkStringLegal(_ AString: String) ->Bool{
        for chr in AString {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }
    
    // check string length no more than 15 characters
    func checkStringLength(_ AString: String, _ length: Int) -> Bool{
        if (AString.count > length){
            return false
        }
        return true
    }
    
    //check is valid height or weight
    func checkNumberValid(_ newNumber: String) ->Bool{
        if (checkIsNumberic(newNumber) && checkStringNotBlank(newNumber)){
            return true
        }
        return false
    }
    
    // check is numberic
    func checkIsNumberic(_ AString: String) -> Bool{
        if Double(AString) != nil{
            return true
        }
        return false
    }
}
