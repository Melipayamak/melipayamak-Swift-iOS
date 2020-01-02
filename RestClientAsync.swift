//
//  RestClientAsync.swift
//  Temperature Converter
//
//  Created by Amirhossein Mehrvarzi on 9/27/19.
//  Copyright © 2019 Melipayamak. All rights reserved.
//

import Foundation

class RestClientAsync : NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate
{
    var mutableData:NSMutableData  = NSMutableData()
    
    let endpoint: String  = "https://rest.payamak-panel.com/api/SendSMS/"
    let sendOp: String = "SendSMS"
    
    let getDeliveryOp: String = "GetDeliveries2"
    let getMessagesOp: String = "GetMessages"
    let getCreditOp: String = "GetCredit"
    let getBasePriceOp: String = "GetBasePrice"
    let getUserNumbersOp: String = "GetUserNumbers"
    let sendByBaseNumberOp: String = "BaseServiceNumber"
    
    let UserName: String
    let Password: String
    
    
    init(user: String, pass: String){
        self.UserName = user
        self.Password = pass
    }
    
    
    func makeRequest(url: URL, values: String){
        
       
        let theRequest = NSMutableURLRequest(url: url)
        
        theRequest.addValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        theRequest.httpMethod = "POST"
        theRequest.httpBody = values.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        NSURLConnection.sendAsynchronousRequest(theRequest as URLRequest, queue: OperationQueue(), completionHandler: {response, data, error in
            
            if (error != nil) {
                print("error: \(String(describing: error))")
            }
            else {
                print("response is: \(String(describing: response))")
            }

        })
        
   
        
    }

    
    
    func Send(to: String, from: String, message: String, isflash: Bool)
    {
        
        let values = "username=\(self.UserName)&password=\(self.Password)&to=\(to)&from=\(from)&text=\(message)&isFlash=\(isflash.description)"
        
        let url = URL(string: endpoint + sendOp)
        
        makeRequest(url: url!, values: values)
        
    }
    
    
    func SendByBaseNumber(text: String, to: String, bodyId: Int32)
    {
        
        let values = "username=\(self.UserName)&password=\(self.Password)&text=\(text)&to=\(to)&bodyId=\(bodyId)"
        
        let url = URL(string: endpoint + sendByBaseNumberOp)
        
        makeRequest(url: url!, values: values)
        
    }
    
    func GetDelivery(recid: Int32)
    {
        
        let values = "username=\(self.UserName)&password=\(self.Password)&recID=\(recid)"
        
        let url = URL(string: endpoint + getDeliveryOp)
        
        makeRequest(url: url!, values: values)
        
    }
    
    //
    func GetMessages(location: Int, from: String, index: String, count: Int)
    {
        
        let values = "username=\(self.UserName)&password=\(self.Password)&Location=\(location)&From=\(from)&Index=\(index)&Count=\(count)"
        
        let url = URL(string: endpoint + getMessagesOp)
        
        makeRequest(url: url!, values: values)
        
    }
    
    func GetCredit()
    {
        
        let values = "username=\(self.UserName)&password=\(self.Password)"
        
        let url = URL(string: endpoint + getCreditOp)
        
        makeRequest(url: url!, values: values)
        
    }
    
    func GetBasePrice()
    {
        
        let values = "username=\(self.UserName)&password=\(self.Password)"
        
        let url = URL(string: endpoint + getBasePriceOp)
        
        makeRequest(url: url!, values: values)
        
    }
    
    func GetUserNumbers()
    {
        
        let values = "username=\(self.UserName)&password=\(self.Password)"
        
        let url = URL(string: endpoint + getUserNumbersOp)
        
        makeRequest(url: url!, values: values)
        
    }
    
    
    
    
    // NSURLConnectionDelegate
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        print("connection error = \(error)")
    }
    
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        mutableData = NSMutableData()
    }
    
    
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        self.mutableData.append(data)
    }
    
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        
        let response : RestResponse = RestResponse(mutableData: mutableData)
        print("status is : \(response.StrRetStatus)")
        
    }
    
    
}
