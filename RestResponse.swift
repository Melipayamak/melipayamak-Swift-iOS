//
//  RestResponse.swift
//  Temperature Converter
//
//  Created by Amirhossein Mehrvarzi on 11/26/19.
//  Copyright © 2019 Melipayamak. All rights reserved.
//

import Foundation

//response class
class RestResponse : NSObject
{
    var Value: String = ""
    var RetStatus: String = ""
    var StrRetStatus: String = ""
    
    
    init(mutableData: NSData) {
        super.init()
        
        let JSONDictionary = try? JSONSerialization.jsonObject(with: mutableData as Data, options: []) as! Dictionary<String, AnyObject>
        
        // Loop
        for (key, value) in JSONDictionary! {
            let keyName = key as String
            
            let keyValue: String = String(describing: value)
            
            // If property exists
            if (self.responds(to: NSSelectorFromString(keyName))) {
                self.setValue(keyValue, forKey: keyName)
            }
        }
        // Or you can do it with using
        // self.setValuesForKeysWithDictionary(JSONDictionary)
        // instead of loop method above
    }
    
    
}
