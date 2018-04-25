//
//  RestClient.swift
//  Temperature Converter
//
//  Created by Amirhossein Mehrvarzi on 4/25/18.
//  Copyright © 2018 Web In Dream. All rights reserved.
//

import Foundation

class RestClient
{
    let endpoint: String  = "https://rest.payamak-panel.com/api/SendSMS/"
    let sendOp: String = "SendSMS"
    
    let getDeliveryOp: String = "GetDeliveries2"
    let getMessagesOp: String = "GetMessages"
    let getCreditOp: String = "GetCredit"
    let getBasePriceOp: String = "GetBasePrice"
    let getUserNumbersOp: String = "GetUserNumbers"
    
    let UserName: String;
    let Password: String;
    
    init(user: String, pass: String){
        self.UserName = user
        self.Password = pass
    }
    
    func Send(to: String, from: String, message: String, isflash: Bool)
{
//    let values:[String: String] = [
//        "username": self.UserName,
//        "password": self.Password,
//        "to": to,
//        "from": from,
//        "text": message,
//        "isFlash": isflash.description
//    ];
    let values = "username=\(self.UserName)&password=\(self.Password)&to=\(to)&from=\(from)&text=\(message)&isFlash=\(isflash.description)"
    
    let url = URL(string: endpoint)
    
    let theRequest = NSMutableURLRequest(url: url!)
    
    //let msgLength = soapMessage.characters.count
    
    theRequest.addValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
    //theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
    theRequest.httpMethod = "POST"
    theRequest.httpBody = //NSKeyedArchiver.archivedData(withRootObject: values)
        values.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
    

    let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
    
    connection!.start()

    
    
    
    
    
//    var content = new FormUrlEncodedContent(values);
//    
//    using (var httpClient = new HttpClient())
//    {
//    var response = httpClient.PostAsync(endpoint + sendOp, content).Result;
//    var responseString = response.Content.ReadAsStringAsync().Result;
//    
//    return JsonConvert.DeserializeObject<RestResponse>(responseString);
//    }
    }
    
    
}


//response class
class RestResponse : NSObject
{
    var Value: String = ""
    var RetStatus: String = ""
    var StrRetStatus: String = ""
    
    
    init(mutableData: NSData) {
        super.init()
        
//        let JSONData = mutableData.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        let JSONDictionary = try? JSONSerialization.jsonObject(with: mutableData as Data, options: []) as! Dictionary<String, AnyObject>
        
        
        // Loop
        for (key, value) in JSONDictionary! {
            let keyName = key as String
            
            let keyValue: String = String(describing: value)
//            var keyValue: String = ""
//            if(value is NSNumber){
//                keyValue = value as! String
//            }
            
            
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


