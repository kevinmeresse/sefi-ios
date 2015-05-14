//
//  Offer.swift
//  sefi
//
//  Created by Kevin Meresse on 4/13/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

import UIKit

class Offer: NSObject {
    
    var id: String?
    var jobTitle: String
    var jobDescription: String?
    var startDate: NSDate
    var location: String?
    var hire: String?
    var contractType: String?
    var conditions: String?
    var availability: String?
    var number: String?
    var carLicence: String?
    var boatLicence: String?
    var degree: String?
    var studiesLevel: String?
    var experience: String?
    var experienceTime: String?
    var softwareExpertise: String?
    var languages: String?
    var applyDate: String?
    var offerDate: String?
    var fullJobTitle: String?
    var companyName: String?
    var companyContact: String?
    var applied: Bool
    var firstName: String?
    var lastName: String?
    
    init(jobTitle: String) {
        self.jobTitle = jobTitle
        self.startDate = NSDate()
        self.applied = false
        super.init()
    }
}
