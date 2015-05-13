//
//  SOAPService.swift
//  sefi
//
//  Created by Kevin Meresse on 4/22/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

import Foundation

/** A simple SOAP client for fetching XML data. */
class SOAPService
{
    /** Prepares a POST request for the specified URL. */
    class func POST(request: NSMutableURLRequest) -> SuccessHandler
    {
        let service = SOAPService(request)
        service.successHandler = SuccessHandler(service: service)
        return service.successHandler!
    }
    
    private init(_ request: NSMutableURLRequest)
    {
        self.request = request
    }
    
    class SuccessHandler
    {
        func success(
            closure: (xml: AnyObject) -> (), // Array or dictionary
            queue:   NSOperationQueue? = nil ) // Background queue by default
            -> ErrorHandler
        {
            self.closure = closure
            self.queue = queue
            service.errorHandler = ErrorHandler(service: service)
            return service.errorHandler!
        }
        
        private init(service: SOAPService)
        {
            self.service = service
            closure = { (_) in return }
        }
        
        private var
        closure: (xml: AnyObject) -> (),
        queue:   NSOperationQueue?,
        service: SOAPService
    }
    
    class ErrorHandler
    {
        func failure(
            closure: (statusCode: Int, error: NSError?) -> (),
            queue:   NSOperationQueue? ) // Background queue by default
        {
            self.closure = closure
            self.queue = queue
            service.execute()
        }
        
        private init(service: SOAPService)
        {
            self.service = service
            closure = { (_,_) in return }
        }
        
        private var
        closure: (statusCode: Int, error: NSError?) -> (),
        queue:   NSOperationQueue?,
        service: SOAPService
    }
    
    private func execute()
    {
        NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                [weak self]
                data, response, error in
                
                // Reference self strongly via `this`
                if let this = self
                {
                    var statusCode = 0
                    if let httpResponse = response as? NSHTTPURLResponse
                    {
                        statusCode = httpResponse.statusCode
                    }
                    
                    this.handleResult(data, error, statusCode)
                }
            }.resume()
    }
    
    private func handleResult(xml: AnyObject?, _ error: NSError?, _ statusCode: Int)
    {
        if xml != nil && NSString(data: xml as! NSData, encoding: NSUTF8StringEncoding) != ""
        {
            let handler  = successHandler!
            let success  = { handler.closure(xml: xml!) }
            if let queue = handler.queue { queue.addOperationWithBlock(success) }
            else                         { success() }
        }
        else
        {
            let handler  = errorHandler!
            let failure  = { handler.closure(statusCode: statusCode, error: error) }
            if let queue = handler.queue { queue.addOperationWithBlock(failure) }
            else                         { failure() }
        }
        
        // Break the retain cycles keeping this object graph alive.
        errorHandler = nil
        successHandler = nil
    }
    
    private var
    errorHandler:   ErrorHandler?,
    successHandler: SuccessHandler?
    
    private let request:  NSMutableURLRequest
}