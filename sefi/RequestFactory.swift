//
//  URLFactory.swift
//  sefi
//
//  Created by Kevin Meresse on 4/20/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

import Foundation

/** Builds the requests needed to call Web services. */
class RequestFactory {
    
    // Production
    //static let host: String = "ws.sefi.pf"
    // Dev
    static let host: String = "localhost"
    
    /** Creates a request to login to the SEFI server. */
    class func login(#id: String, birthdate: String) -> NSMutableURLRequest
    {
        let url = NSURL(string: "http://\(host)/4DSOAP/WSM_Login")!
        let request = NSMutableURLRequest(URL: url)
        var args = [SOAPArgument]()
        args.append(SOAPArgument(name: "in_ws_NumDem", type: "int", value: id))
        args.append(SOAPArgument(name: "in_ws_DateNaissance", type: "date", value: birthdate))
        args.append(SOAPArgument(name: "in_ws_AdressIP", type: "string", value: ""))
        args.append(SOAPArgument(name: "in_ws_Origin", type: "string", value: "iOS"))
        let soapMessage = SOAPFormatter.getRequestBody("WSM_Login", args: args)
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("WS_SefiGest#WSM_Login", forHTTPHeaderField: "SOAPAction")
        request.HTTPMethod = "POST"
        request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        return request
    }
    
    /** Creates a request to retrieve new offers from the SEFI server. */
    class func retrieveNewOffers() -> NSMutableURLRequest
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        let id = defaults.stringForKey(User.usernameKey)
        let birthdate = defaults.stringForKey(User.birthdateKey)
        
        let url = NSURL(string: "http://\(host)/4DSOAP/WSM_Get_Offres")!
        let request = NSMutableURLRequest(URL: url)
        var args = [SOAPArgument]()
        args.append(SOAPArgument(name: "in_ws_NumDem", type: "int", value: id!))
        args.append(SOAPArgument(name: "in_ws_DateNaissance", type: "date", value: birthdate!))
        args.append(SOAPArgument(name: "in_ws_AdressIP", type: "string", value: ""))
        args.append(SOAPArgument(name: "in_ws_Origin", type: "string", value: "iOS"))
        let soapMessage = SOAPFormatter.getRequestBody("WSM_Get_Offres", args: args)
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("WS_SefiGest#WSM_Get_Offres", forHTTPHeaderField: "SOAPAction")
        request.HTTPMethod = "POST"
        request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        return request
    }
    
    /** Creates a request to retrieve applied offers from the SEFI server. */
    class func retrieveAppliedOffers() -> NSMutableURLRequest
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        let id = defaults.stringForKey(User.usernameKey)
        let birthdate = defaults.stringForKey(User.birthdateKey)
        
        let url = NSURL(string: "http://\(host)/4DSOAP/WSM_Get_Offres_Postulees")!
        let request = NSMutableURLRequest(URL: url)
        var args = [SOAPArgument]()
        args.append(SOAPArgument(name: "in_ws_NumDem", type: "int", value: id!))
        args.append(SOAPArgument(name: "in_ws_DateNaissance", type: "date", value: birthdate!))
        args.append(SOAPArgument(name: "in_ws_AdressIP", type: "string", value: ""))
        args.append(SOAPArgument(name: "in_ws_Origin", type: "string", value: "iOS"))
        let soapMessage = SOAPFormatter.getRequestBody("WSM_Get_Offres_Postulees", args: args)
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("WS_SefiGest#WSM_Get_Offres_Postulees", forHTTPHeaderField: "SOAPAction")
        request.HTTPMethod = "POST"
        request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        return request
    }
    
    /** Creates a request to retrieve applied offers from the SEFI server. */
    class func applyOffer(offer: Offer) -> NSMutableURLRequest
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        let id = defaults.stringForKey(User.usernameKey)
        
        let url = NSURL(string: "http://\(host)/4DSOAP/WSM_Relation")!
        let request = NSMutableURLRequest(URL: url)
        var args = [SOAPArgument]()
        args.append(SOAPArgument(name: "in_ws_NumDem", type: "int", value: id!))
        args.append(SOAPArgument(name: "in_ws_NumOff", type: "int", value: offer.id!))
        args.append(SOAPArgument(name: "in_ws_AdressIP", type: "string", value: ""))
        args.append(SOAPArgument(name: "in_ws_Origin", type: "string", value: "iOS"))
        let soapMessage = SOAPFormatter.getRequestBody("WSM_Relation", args: args)
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("WS_SefiGest#WSM_Relation", forHTTPHeaderField: "SOAPAction")
        request.HTTPMethod = "POST"
        request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        println("Making Relation request with offer id: \(offer.id!)")
        
        return request
    }
}