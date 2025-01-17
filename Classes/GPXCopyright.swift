//
//  GPXCopyright.swift
//  GPXKit
//
//  Created by Vincent on 22/11/18.
//

import Foundation

/**
 A value type for representing copyright info

 Copyight information also includes additional attributes.
 
 **Supported attributes:**
 - Year of first publication
 - License of the file
 - Author / Copyright Holder's name
 
*/
open class GPXCopyright: GPXElement, Codable {
    
    /// Year of the first publication of this copyrighted work.
    ///
    /// This should be the current year.
    ///
    ///     year = Date()
    ///     // year attribute will be current year.
    public var year: Date?
    
    /// License of the file.
    ///
    /// A URL linking to the license's documentation, represented with a `String`
    public var license: String?
    
    /// Author / copyright holder's name.
    ///
    /// Basically, the person who has created this GPX file, which is also the copyright holder, shall them wish to have it as a copyrighted work.
    public var author: String?
    
    // MARK:- Instance
    
    /// Default Initializer.
    public required init() {
        super.init()
    }
    
    /// Initializes with author
    ///
    /// At least the author name must be valid in order for a `GPXCopyright` to be valid.
    public init(author: String) {
        super.init()
        self.author = author
        self.year = Date()
    }
    
    /// For internal use only
    ///
    /// Initializes a waypoint through a dictionary, with each key being an attribute name.
    ///
    /// - Remark:
    /// This initializer is designed only for use when parsing GPX files, and shouldn't be used in other ways.
    ///
    /// - Parameters:
    ///     - dictionary: a dictionary with a key of an attribute, followed by the value which is set as the GPX file is parsed.
    ///
    init(dictionary: [String : String]) {
        super.init()
        self.year = GPXDateParser.parse(year: dictionary["year"])
        self.license = dictionary["license"]
        self.author = dictionary["author"]
    }
    
    init(raw: GPXRawElement) {
        for child in raw.children {
            switch child.name {
            case "year":    self.year = GPXDateParser.parse(year: child.text)
            case "license": self.license = child.text
            default: continue
            }
        }
        self.author = raw.attributes["author"]
    }
    
    // MARK: Tag
    
    override func tagName() -> String {
        return "copyright"
    }
    
    // MARK: GPX
    
    override func addOpenTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        let attribute = NSMutableString()
        
        if let author = author {
            attribute.appendFormat(" author=\"%@\"", author)
        }
        
        gpx.appendOpenTag(indentation: indent(forIndentationLevel: indentationLevel), tag: tagName(), attribute: attribute)
    }
    
    override func addChildTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        super.addChildTag(toGPX: gpx, indentationLevel: indentationLevel)
        self.addProperty(forValue: Convert.toString(fromYear: year), gpx: gpx, tagName: "year", indentationLevel: indentationLevel)
        self.addProperty(forValue: license, gpx: gpx, tagName: "license", indentationLevel: indentationLevel)
    }
}
