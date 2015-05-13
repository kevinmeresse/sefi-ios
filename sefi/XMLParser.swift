//
//  XMLParser.swift
//  sefi
//
//  Created by Kevin Meresse on 4/23/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

import Foundation

class XMLParser {
    
    class func checkIfAuthenticated(xml: AnyObject) -> (authenticated: Bool, message: String) {
        println(NSString(data: xml as! NSData, encoding: NSUTF8StringEncoding))
        
        let parsedXml = SWXMLHash.parse(xml as! NSData)
        let loginStatus = parsedXml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:WSM_LoginResponse"]["out_ws_Status"].element?.text
        let loginMessage = parsedXml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:WSM_LoginResponse"]["out_ws_Message"].element?.text
        
        let isAuthenticated: Bool = loginStatus?.toInt()! == 0 ? true : false
        return (isAuthenticated, loginMessage!)
    }
    
    class func createOffers(xml: AnyObject, isNewOffers: Bool) -> [Offer] {
        println(NSString(data: xml as! NSData, encoding: NSUTF8StringEncoding))
        
        var offers = [Offer]()
        let parsedXml = SWXMLHash.parse(xml as! NSData)
        
        let body = isNewOffers ? "ns1:WSM_Get_OffresResponse" : "ns1:WSM_Get_Offres_PostuleesResponse"
        
        let offersArray = parsedXml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["\(body)"]["out_ws_DEM_Structure"]["OFFRE"]
        for offer in offersArray {
            let jobTitle = offer["OFF_ROM_Fonction"].element?.text
            let newOffer = Offer(jobTitle: jobTitle!)
            newOffer.id = offer["OFF_Num"].element?.text
            newOffer.location = offer["OFF_Lieu"].element?.text
            newOffer.number = offer["OFF_Nbr_Postes"].element?.text
            newOffer.contractType = offer["OFF_Contrat_Type"].element?.text
            newOffer.availability = offer["OFF_aPourvoir"].element?.text
            newOffer.carLicence = offer["OFF_Motorise_Permis"].element?.text
            newOffer.boatLicence = offer["OFF_Permis_Bateau"].element?.text
            newOffer.degree = offer["OFF_Diplome"].element?.text
            newOffer.studiesLevel = offer["OFF_Niv_Etude"].element?.text
            newOffer.experience = offer["OFF_Exp_Obligatoire"].element?.text
            newOffer.experienceTime = offer["OFF_Exp_Duree"].element?.text
            newOffer.jobDescription = offer["OFF_Descriptif"].element?.text
            newOffer.conditions = offer["OFF_Conditions"].element?.text
            newOffer.softwareExpertise = offer["OFF_Informatique"].element?.text
            newOffer.languages = offer["OFF_Langues"].element?.text
            offers.append(newOffer)
        }
        
        return offers
    }
    
    class func checkIfApplied(xml: AnyObject) -> (applied: Bool, message: String?) {
        println(NSString(data: xml as! NSData, encoding: NSUTF8StringEncoding))
        
        let parsedXml = SWXMLHash.parse(xml as! NSData)
        let status = parsedXml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:WSM_RelationResponse"]["out_ws_Status"].element?.text
        let message = parsedXml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:WSM_RelationResponse"]["out_ws_Message"].element?.text
        
        let isApplied: Bool = status?.toInt()! == 1 ? true : false
        return (isApplied, message)
    }
}