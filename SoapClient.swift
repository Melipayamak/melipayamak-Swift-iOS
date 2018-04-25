//
//  SoapClient.swift
//  MeliPayamak
//
//  Created by Amirhossein Mehrvarzi on 4/25/18.
//  Copyright © 2018 MeliPayamak. All rights reserved.
//

import Foundation

import UIKit

//Add protocol names that we will be delegating.
class soapClient : NSObject, NSURLConnectionDelegate,NSURLConnectionDataDelegate,  XMLParserDelegate {
    
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:String = ""  //to match inner xml tag (response)
    var response : String = ""
    
    var username: String
    var password: String
    
    init(user: String, pass: String) {
        self.username = user
        self.password = pass
    }
    
    
    func SendSimpleSMS2(to: String, from: String, msg: String, isFlash: Bool) {
        
        //copy related soap request structure here
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><SendSimpleSMS2 xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(to)</to><from>\(from)</from><text>\(msg)</text><isflash>\(isFlash)</isflash></SendSimpleSMS2></soap:Body></soap:Envelope>"
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
    
    // NSURLConnectionDelegate
    // NSURL
    
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
        if currentElementName == "SendSimpleSMS2Result" { //name of inner <tag> in soap response
            response = string
        }
    }
    
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        
        let xmlParser = XMLParser(data: mutableData as Data)
        xmlParser.delegate = self
        xmlParser.parse()
        xmlParser.shouldResolveExternalEntities = true
    }
    
}
