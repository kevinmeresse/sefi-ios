//
//  StringFormatter.swift
//  sefi
//
//  Created by Kevin Meresse on 4/24/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

import Foundation

class StringFormatter {
    
    class func getXmlDate(date: String) -> String {
        var dateArray = split(date) {$0 == "/"}
        if dateArray.count == 3 {
            return "\(dateArray[2])-\(dateArray[1])-\(dateArray[0])"
        }
        return date
    }
}