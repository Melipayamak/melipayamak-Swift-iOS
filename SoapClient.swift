//
//  SoapClient.swift
//  MeliPayamak
//
//  Created by Amirhossein Mehrvarzi on 4/25/18.
//  Copyright © 2018 MeliPayamak. All rights reserved.
//

import Foundation

import UIKit

class soapClient : NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate,  XMLParserDelegate {
    
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:String = ""  //to match inner xml tag (response)
    var expectedElementName:String = "" //to match inner xml tag (response)
    var response : String = ""
    
    var username: String
    var password: String
    
    init(user: String, pass: String) {
        self.username = user
        self.password = pass
    }
    
    //Send API Operations
    
    func SendSimpleSMS2(to: String, from: String, msg: String, isFlash: Bool) {
        
        //copy related soap request structure here
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><SendSimpleSMS2 xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(to)</to><from>\(from)</from><text>\(msg)</text><isflash>\(isFlash)</isflash></SendSimpleSMS2></soap:Body></soap:Envelope>"
        expectedElementName = "SendSimpleSMS2Result"
        //use related webservice url here
        let urlString = "http://api.payamak-panel.com/post/send.asmx"
        
        let url = URL(string: urlString)
        
        let theRequest = NSMutableURLRequest(url: url!)
        
        let msgLength = soapMessage.characters.count
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
        
        connection!.start()
    }

    func SendSimpleSMS(to: [String], from: String, msg: String, isFlash: Bool) {
        //prepare arrays to use in soap request
        
        let stringSplitter = "</string><string>"
        _to = "<string>" + to.joined(separator: stringSplitter) + "</string>"
        
        //copy related soap request structure here
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><SendSimpleSMS xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(_to)</to><from>\(from)</from><text>\(msg)</text><isflash>\(isFlash)</isflash></SendSimpleSMS></soap:Body></soap:Envelope>"
        expectedElementName = "SendSimpleSMSResponse"
        //use related webservice url here
        let urlString = "http://api.payamak-panel.com/post/send.asmx"
        
        let url = URL(string: urlString)
        
        let theRequest = NSMutableURLRequest(url: url!)
        
        let msgLength = soapMessage.characters.count
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
        
        connection!.start()
    }

    func SendSms(to: [String], from: String, msg: String, isFlash: Bool, udh: String, recid: [Int64]) {
        //prepare arrays to use in soap request
        var recidAsStringArray = recid.map { String($0) }
        let longSplitter = "</long><long>"
        let stringSplitter = "</string><string>"
        _to = "<string>" + to.joined(separator: stringSplitter) + "</string>"
        _recid = "<long>" + recidAsStringArray.joined(separator: longSplitter) + "</long>"

        //copy related soap request structure here
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><SendSms xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(_to)</to><from>\(from)</from><text>\(msg)</text><isflash>\(isFlash)</isflash><udh>\(udh)</udh><recId>\(_recid)</recId><status></status></SendSms></soap:Body></soap:Envelope>"
        expectedElementName = "SendSmsResponse"
        //use related webservice url here
        let urlString = "http://api.payamak-panel.com/post/send.asmx"
        
        let url = URL(string: urlString)
        
        let theRequest = NSMutableURLRequest(url: url!)
        
        let msgLength = soapMessage.characters.count
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
        
        connection!.start()
    }

    func SendWithDomain(to: String, from: String, msg: String, isFlash: Bool, domain: String) {
        
        //copy related soap request structure here
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><SendWithDomain xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(to)</to><from>\(from)</from><text>\(msg)</text><isflash>\(isFlash)</isflash><domainName>\(domain)</domainName></SendWithDomain></soap:Body></soap:Envelope>"
        expectedElementName = "SendWithDomainResponse"
        //use related webservice url here
        let urlString = "http://api.payamak-panel.com/post/send.asmx"
        
        let url = URL(string: urlString)
        
        let theRequest = NSMutableURLRequest(url: url!)
        
        let msgLength = soapMessage.characters.count
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
        
        connection!.start()
    }

    func getMessages(location: Int, from: String, index: Int, count: Int) {
        
        //copy related soap request structure here
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><getMessages xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><location>\(location)</location><from>\(from)</from><index>\(index)</index><count>\(count)</count></getMessages></soap:Body></soap:Envelope>"
        expectedElementName = "getMessagesResponse"
        //use related webservice url here
        let urlString = "http://api.payamak-panel.com/post/send.asmx"
        
        let url = URL(string: urlString)
        
        let theRequest = NSMutableURLRequest(url: url!)
        
        let msgLength = soapMessage.characters.count
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
        
        connection!.start()
    }

    func GetSmsPrice(irancellCount: Int, mtnCount: Int, from: String, text: String) {
        
        //copy related soap request structure here
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetSmsPrice xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><irancellCount>\(irancellCount)</irancellCount><mtnCount>\(mtnCount)</mtnCount><from>\(from)</from><text>\(text)</text></GetSmsPrice></soap:Body></soap:Envelope>"
        expectedElementName = "GetSmsPriceResponse"
        //use related webservice url here
        let urlString = "http://api.payamak-panel.com/post/send.asmx"
        
        let url = URL(string: urlString)
        
        let theRequest = NSMutableURLRequest(url: url!)
        
        let msgLength = soapMessage.characters.count
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
        
        connection!.start()
    }

    func GetMultiDelivery2(recId: String) {
        
        //copy related soap request structure here
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetMultiDelivery2 xmlns='http://tempuri.org/'><recId>\(recId)</recId></GetMultiDelivery2></soap:Body></soap:Envelope>"
        expectedElementName = "GetMultiDelivery2Response"
        //use related webservice url here
        let urlString = "http://api.payamak-panel.com/post/send.asmx"
        
        let url = URL(string: urlString)
        
        let theRequest = NSMutableURLRequest(url: url!)
        
        let msgLength = soapMessage.characters.count
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
        
        connection!.start()
    }    

    func GetMultiDelivery(recId: String) {
        
        //copy related soap request structure here
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetMultiDelivery xmlns='http://tempuri.org/'><recId>\(recId)</recId></GetMultiDelivery></soap:Body></soap:Envelope>"
        expectedElementName = "GetMultiDeliveryResponse"
        //use related webservice url here
        let urlString = "http://api.payamak-panel.com/post/send.asmx"
        
        let url = URL(string: urlString)
        
        let theRequest = NSMutableURLRequest(url: url!)
        
        let msgLength = soapMessage.characters.count
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
        
        connection!.start()
    } 

    func GetInboxCount(isRead: Bool) {
        
        //copy related soap request structure here
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetInboxCount xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><isRead>\(isRead)</isRead></GetInboxCount></soap:Body></soap:Envelope>"
        expectedElementName = "GetInboxCountResponse"
        //use related webservice url here
        let urlString = "http://api.payamak-panel.com/post/send.asmx"
        
        let url = URL(string: urlString)
        
        let theRequest = NSMutableURLRequest(url: url!)
        
        let msgLength = soapMessage.characters.count
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
        
        connection!.start()
    }

    func GetDelivery2(recId: String) {
        
        //copy related soap request structure here
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetDelivery2 xmlns='http://tempuri.org/'><recId>\(recId)</recId></GetDelivery2></soap:Body></soap:Envelope>"
        expectedElementName = "GetDelivery2Response"
        //use related webservice url here
        let urlString = "http://api.payamak-panel.com/post/send.asmx"
        
        let url = URL(string: urlString)
        
        let theRequest = NSMutableURLRequest(url: url!)
        
        let msgLength = soapMessage.characters.count
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
        
        connection!.start()
    } 

    func GetDelivery(recId: Int64) {
        
        //copy related soap request structure here
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetDelivery xmlns='http://tempuri.org/'><recId>\(recId)</recId></GetDelivery></soap:Body></soap:Envelope>"
        expectedElementName = "GetDeliveryResponse"
        //use related webservice url here
        let urlString = "http://api.payamak-panel.com/post/send.asmx"
        
        let url = URL(string: urlString)
        
        let theRequest = NSMutableURLRequest(url: url!)
        
        let msgLength = soapMessage.characters.count
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
        
        connection!.start()
    } 

    func GetDeliveries3(recIds: [String]) {
        
        let stringSplitter = "</string><string>"
        _recids = "<string>" + recIds.joined(separator: stringSplitter) + "</string>"
        //copy related soap request structure here
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetDeliveries3 xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><recId>\(_recids)</recId></GetDeliveries3></soap:Body></soap:Envelope>"
        expectedElementName = "GetDeliveries3Response"
        //use related webservice url here
        let urlString = "http://api.payamak-panel.com/post/send.asmx"
        
        let url = URL(string: urlString)
        
        let theRequest = NSMutableURLRequest(url: url!)
        
        let msgLength = soapMessage.characters.count
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
        
        connection!.start()
    }   

    func GetDeliveries2(recId: String) {
        
        //copy related soap request structure here
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetDeliveries2 xmlns='http://tempuri.org/'><recId>\(recId)</recId></GetDeliveries2></soap:Body></soap:Envelope>"
        expectedElementName = "GetDeliveries2Response"
        //use related webservice url here
        let urlString = "http://api.payamak-panel.com/post/send.asmx"
        
        let url = URL(string: urlString)
        
        let theRequest = NSMutableURLRequest(url: url!)
        
        let msgLength = soapMessage.characters.count
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
        
        connection!.start()
    }    

    func GetDeliveries(recIds: [Int64]) {
        
        let longSplitter = "</long><long>"
        _recids = "<long>" + recIds.joined(separator: longSplitter) + "</long>"
        //copy related soap request structure here
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetDeliveries xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><recIds>\(_recids)</recIds></GetDeliveries></soap:Body></soap:Envelope>"
        expectedElementName = "GetDeliveriesResponse"
        //use related webservice url here
        let urlString = "http://api.payamak-panel.com/post/send.asmx"
        
        let url = URL(string: urlString)
        
        let theRequest = NSMutableURLRequest(url: url!)
        
        let msgLength = soapMessage.characters.count
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
        
        connection!.start()
    } 

    func GetCredit() {
        
        //copy related soap request structure here
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetCredit xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></GetCredit></soap:Body></soap:Envelope>"
        expectedElementName = "GetCreditResponse"
        //use related webservice url here
        let urlString = "http://api.payamak-panel.com/post/send.asmx"
        
        let url = URL(string: urlString)
        
        let theRequest = NSMutableURLRequest(url: url!)
        
        let msgLength = soapMessage.characters.count
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
        
        connection!.start()
    }     

    //Receive API Operations
    func RemoveMessages2(location: Int, msgIds: String) {
        
        //copy related soap request structure here
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><RemoveMessages2 xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><location>\(location)</location><msgIds>\(msgIds)</msgIds></RemoveMessages2></soap:Body></soap:Envelope>"
        expectedElementName = "RemoveMessages2Response"
        //use related webservice url here
        let urlString = "http://api.payamak-panel.com/post/receive.asmx"
        
        let url = URL(string: urlString)
        
        let theRequest = NSMutableURLRequest(url: url!)
        
        let msgLength = soapMessage.characters.count
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
        
        connection!.start()
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
    
    
    
    // NSXMLParserDelegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElementName = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElementName == expectedElementName { //name of inner <tag> in soap response
            response = string //parse it based on your need
        }
    }
    
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        
        let xmlParser = XMLParser(data: mutableData as Data)
        xmlParser.delegate = self
        xmlParser.parse()
        xmlParser.shouldResolveExternalEntities = true
    }
    
}
