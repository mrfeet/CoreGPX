//
//  GPXEmail.swift
//  GPXKit
//
//  Created by Vincent on 18/11/18.
//

import Foundation

/**
 Used for handling email types
 
 Email is seperated as two variables in order to prevent email harvesting. The GPX v1.1 schema requires that.
 */
open class GPXEmail: GPXElement {
    
    public var emailID: String?
    public var domain: String?
    
    // MARK:- Instance
    
    public required init() {
        self.emailID = String()
        self.domain = String()
        super.init()
    }
    
    public init(withFullEmailAddress email: String) {
        let splitedEmail = email.components(separatedBy: "@")
        self.emailID = splitedEmail[0]
        self.domain = splitedEmail[1]
    }
    
    public init(emailID: String, domain: String) {
        self.emailID = emailID
        self.domain = domain
    }
    
    init(dictionary: [String : String]) {
        self.emailID = dictionary["id"]
        self.domain = dictionary["domain"]
    }
    
    // MARK:- Tag
    override func tagName() -> String {
        return "email"
    }
    
    // MARK:- GPX
    override func addOpenTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        let attribute = NSMutableString()
        
        if let emailID = emailID {
            attribute.appendFormat(" id=\"%@\"", emailID)
        }
        if let domain = domain {
            attribute.appendFormat(" domain=\"%@\"", domain)
        }
        gpx.appendFormat("%@<%@%@>\r\n", indent(forIndentationLevel: indentationLevel), self.tagName(), attribute)
    }
}
