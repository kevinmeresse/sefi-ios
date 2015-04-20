//
//  Offer.swift
//  sefi
//
//  Created by Kevin Meresse on 4/13/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

import UIKit

class Offer: NSObject {
    
    var jobTitle: String
    var jobDescription: String = ""
    var startDate: NSDate
    var location: String = ""
    var hire: String = ""
    var contract: String = ""
    var jobTime: String = ""
    var salary: Int = 0
    var perks: String = ""
    
    init(jobTitle: String) {
        self.jobTitle = jobTitle
        self.startDate = NSDate()
        super.init()
    }
    
    convenience init(jobTitle: String, jobDescription: String, startDate: NSDate, location: String, hire: String, contract: String, jobTime: String, salary: Int, perks: String) {
        self.init(jobTitle: jobTitle)
        self.jobDescription = jobDescription
        self.startDate = startDate
        self.location = location
        self.hire = hire
        self.contract = contract
        self.jobTime = jobTime
        self.salary = salary
        self.perks = perks
    }
}
