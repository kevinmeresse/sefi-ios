//
//  DateFormatter.swift
//  sefi
//
//  Created by Kevin Meresse on 4/20/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

import Foundation

/** Creates display text from a Date object. */
class DateFormatter {
    
    static let localeId = "fr_FR"
    
    /** Returns a date formatted like: dd/mm/yyyy */
    class func getSimpleDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: localeId)
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        return dateFormatter.stringFromDate(date)
    }
}