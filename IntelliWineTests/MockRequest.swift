//
//  MockRequest.swift
//  IntelliWineTests
//
//  Created by Rolland Cédric on 29.11.17.
//  Copyright © 2017 IntelliWine. All rights reserved.
//

import Foundation

public class MockRequest {
    
    var request:String?
    
    struct response {
        static var data:HTTPURLResponse?
        static var json:AnyObject?
        static var error:NSError?
    }
    
    init (request: String) {
        self.request = request
    }
    
    public func responseJSON(options: JSONSerialization.ReadingOptions = .allowFragments, completionHandler: (NSURLRequest, HTTPURLResponse?, AnyObject?, NSError?) -> Void) -> Self {
        
        completionHandler(NSURLRequest(url: NSURL(string: self.request!)! as URL), MockRequest.response.data, MockRequest.response.json, MockRequest.response.error)
        return self
    }
}

