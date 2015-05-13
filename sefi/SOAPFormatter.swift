//
//  SOAPFormatter.swift
//  sefi
//
//  Created by Kevin Meresse on 4/22/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

import Foundation

class SOAPFormatter {
    
    /** Returns a SOAP body */
    class func getRequestBody(method: String, args: [SOAPArgument]) -> String {
        var soapBody: String = "<?xml version='1.0' encoding='UTF-8'?><soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'><soapenv:Body><ns1:\(method) soapenv:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/' xmlns:ns1='http://sefigest.sefi.pf/namespace/default'>"
        for arg in args {
            soapBody += "<\(arg.name) xsi:type='xsd:\(arg.type)'>\(arg.value)</\(arg.name)>"
        }
        soapBody += "</ns1:\(method)></soapenv:Body></soapenv:Envelope>"
        return soapBody
    }
    
    /**
    Attempts to convert the specified data object to XML data
    objects and returns either the root XML object or an error.
    */
    func XMLObjectWithData(
        data:    NSData,
        options: NSJSONReadingOptions = nil)
        -> XMLObjectWithDataResult
    {
        var error: NSError?
        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(
            data,
            options: options,
            error:  &error)
        return json != nil
            ? .Success(json!)
            : .Failure(error ?? NSError())
    }
    
    /** All possible outputs of the XMLObjectWithData function. */
    enum XMLObjectWithDataResult
    {
        case Success(AnyObject)
        case Failure(NSError)
    }
}

class SOAPArgument: NSObject {
    let name: String
    let type: String
    let value: String
    
    init(name: String, type: String, value: String) {
        self.name = name
        self.type = type
        self.value = value
        super.init()
    }
}



