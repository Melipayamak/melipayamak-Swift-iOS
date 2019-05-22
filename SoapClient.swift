//
//  SoapClient.swift
//  MeliPayamak
//
//  Created by Amirhossein Mehrvarzi on 4/25/18.
//  Copyright © 2018 MeliPayamak. All rights reserved.
//

import Foundation

import UIKit

class SoapClient : NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate,  XMLParserDelegate {
    var mutableData:NSMutableData  = NSMutableData()

    var currentElementName:String = ""  //to match inner xml tag (response)

    var expectedElementName:String = "" //to match inner xml tag (response)

    var response : String = ""

    

    var username: String

    var password: String

    

    let _sendEndpoint = "http://api.payamak-panel.com/post/send.asmx"

    let _receiveEndpoint = "http://api.payamak-panel.com/post/receive.asmx"

    let _usersEndpoint = "http://api.payamak-panel.com/post/Users.asmx"

    let _contactsEndpoint = "http://api.payamak-panel.com/post/contacts.asmx"

    let _actionsEndpoint = "http://api.payamak-panel.com/post/actions.asmx"

    let _scheduleEndpoint = "http://api.payamak-panel.com/post/Schedule.asmx"
    
    let _voiceEndpoint = "http://api.payamak-panel.com/post/voice.asmx"

    

    

    init(user: String, pass: String) {

        self.username = user

        self.password = pass

    }

    

    func initAndSendRequest(endpoint: String, message: String){

        

        let url = URL(string: endpoint)

        

        let theRequest = NSMutableURLRequest(url: url!)

        

        let msgLength = message.characters.count

        

        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")

        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")

        theRequest.httpMethod = "POST"

        theRequest.httpBody = message.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false

        

        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)

        

        connection!.start()

    }

    

    //Send API Operations

    

    func SendSimpleSMS2(to: String, from: String, msg: String, isFlash: Bool) {

        let sendingElementName = "SendSimpleSMS2"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(to)</to><from>\(from)</from><text>\(msg)</text><isflash>\(isFlash)</isflash></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func SendSimpleSMS(to: [String], from: String, msg: String, isFlash: Bool) {


        let stringSplitter = "</string><string>"

        let _to = "<string>" + to.joined(separator: stringSplitter) + "</string>"

        let sendingElementName = "SendSimpleSMS"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(_to)</to><from>\(from)</from><text>\(msg)</text><isflash>\(isFlash)</isflash></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func SendSms(to: [String], from: String, msg: String, isFlash: Bool, udh: String, recid: [Int64]) {

        let recidAsStringArray = recid.map { String($0) }

        let longSplitter = "</long><long>"

        let stringSplitter = "</string><string>"

        let _to = "<string>" + to.joined(separator: stringSplitter) + "</string>"

        let _recid = "<long>" + recidAsStringArray.joined(separator: longSplitter) + "</long>"

        let sendingElementName = "SendSms"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(_to)</to><from>\(from)</from><text>\(msg)</text><isflash>\(isFlash)</isflash><udh>\(udh)</udh><recId>\(_recid)</recId><status></status></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    
    func SendByBaseNumber(text: [String], to: String, bodyId: Int32) {

        let stringSplitter = "</string><string>"

        let _text = "<string>" + text.joined(separator: stringSplitter) + "</string>"

        let sendingElementName = "SendByBaseNumber"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><text>\(_text)</text><to>\(to)</to><bodyId>\(bodyId)</bodyId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }


    func SendByBaseNumber2(text: String, to: String, bodyId: Int32) {

        let sendingElementName = "SendByBaseNumber2"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><text>\(text)</text><to>\(to)</to><bodyId>\(bodyId)</bodyId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }
    

    func SendWithDomain(to: String, from: String, msg: String, isFlash: Bool, domain: String) {


        let sendingElementName = "SendWithDomain"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(to)</to><from>\(from)</from><text>\(msg)</text><isflash>\(isFlash)</isflash><domainName>\(domain)</domainName></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func getMessages(location: Int, from: String, index: Int, count: Int) {

        let sendingElementName = "getMessages"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><location>\(location)</location><from>\(from)</from><index>\(index)</index><count>\(count)</count></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func GetSmsPrice(irancellCount: Int, mtnCount: Int, from: String, text: String) {

        let sendingElementName = "GetSmsPrice"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><irancellCount>\(irancellCount)</irancellCount><mtnCount>\(mtnCount)</mtnCount><from>\(from)</from><text>\(text)</text></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func GetMultiDelivery2(recId: String) {

        let sendingElementName = "GetMultiDelivery2"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><recId>\(recId)</recId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func GetMultiDelivery(recId: String) {

        let sendingElementName = "GetMultiDelivery"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><recId>\(recId)</recId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func GetInboxCount(isRead: Bool) {

        let sendingElementName = "GetInboxCount"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><isRead>\(isRead)</isRead></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func GetDelivery2(recId: String) {

        let sendingElementName = "GetDelivery2"
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><recId>\(recId)</recId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func GetDelivery(recId: Int64) {

        let sendingElementName = "GetDelivery"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><recId>\(recId)</recId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func GetDeliveries3(recIds: [String]) {
        

        let stringSplitter = "</string><string>"

        let _recids = "<string>" + recIds.joined(separator: stringSplitter) + "</string>"

        let sendingElementName = "GetDeliveries3"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><recId>\(_recids)</recId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func GetDeliveries2(recId: String) {

        let sendingElementName = "GetDeliveries2"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><recId>\(recId)</recId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func GetDeliveries(recIds: [Int64]) {
        

        let recidAsStringArray = recIds.map { String($0) }

        let longSplitter = "</long><long>"

        let _recids = "<long>" + recidAsStringArray.joined(separator: longSplitter) + "</long>"

        let sendingElementName = "GetDeliveries"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><recIds>\(_recids)</recIds></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func GetCredit() {

        let sendingElementName = "GetCredit"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    //Receive API Operations

    func RemoveMessages2(location: Int, msgIds: String) {

        let sendingElementName = "RemoveMessages2"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><location>\(location)</location><msgIds>\(msgIds)</msgIds></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    //use Received or Sent or Removed or Deleted for location in the next method

    func RemoveMessages(location: String, msgIds: String) {

        let sendingElementName = "RemoveMessages"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><location>\(location)</location><msgIds>\(msgIds)</msgIds></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    

    func GetUsersMessagesByDate(location: Int, from: String, index: Int, count: Int, dateFrom: Date, dateTo: Date) {

        let sendingElementName = "GetUsersMessagesByDate"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><location>\(location)</location><from>\(from)</from><index>\(index)</index><count>\(count)</count><dateFrom>\(dateFrom)</dateFrom><dateTo>\(dateTo)</dateTo></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    

    func GetOutBoxCount() {

        let sendingElementName = "GetOutBoxCount"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    

    func GetMessagesWithChangeIsRead(location: Int, from: String, index: Int, count: Int, isRead: Bool, changeIsRead: Bool) {

        let sendingElementName = "GetMessagesWithChangeIsRead"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><location>\(location)</location><from>\(from)</from><index>\(index)</index><count>\(count)</count><isRead>\(isRead)</isRead><changeIsRead>\(changeIsRead)</changeIsRead></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    

    func GetMessagesReceptions(msgId: Int, fromRows: Int) {

        let sendingElementName = "GetMessagesReceptions"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><msgId>\(msgId)</msgId><fromRows>\(fromRows)</fromRows></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    

    func GetMessagesFilterByDate(location: Int, from: String, index: Int, count: Int, dateFrom: Date, dateTo: Date, isRead: Bool) {

        let sendingElementName = "GetMessagesFilterByDate"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><location>\(location)</location><from>\(from)</from><index>\(index)</index><count>\(count)</count><dateFrom>\(dateFrom)</dateFrom><dateTo>\(dateTo)</dateTo><isRead>\(isRead)</isRead></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    

    func GetMessagesByDate(location: Int, from: String, index: Int, count: Int, dateFrom: Date, dateTo: Date) {

        let sendingElementName = "GetMessagesByDate"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><location>\(location)</location><from>\(from)</from><index>\(index)</index><count>\(count)</count><dateFrom>\(dateFrom)</dateFrom><dateTo>\(dateTo)</dateTo></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    

    func GetMessagesAfterIDJson(location: Int, from: String, count: Int, msgId: Int) {

        let sendingElementName = "GetMessagesAfterIDJson"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><location>\(location)</location><from>\(from)</from><count>\(count)</count><msgId>\(msgId)</msgId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    

    func GetMessagesAfterID(location: Int, from: String, count: Int, msgId: Int) {

        let sendingElementName = "GetMessagesAfterID"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><location>\(location)</location><from>\(from)</from><count>\(count)</count><msgId>\(msgId)</msgId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    

    func GetMessages(location: Int, from: String, index: Int, count: Int) {

        let sendingElementName = "GetMessages"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><location>\(location)</location><from>\(from)</from><index>\(index)</index><count>\(count)</count></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    

    func GetMessageStr(location: Int, from: String, index: Int, count: Int) {

        let sendingElementName = "GetMessageStr"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><location>\(location)</location><from>\(from)</from><index>\(index)</index><count>\(count)</count></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    

    //duplicate function

//    func GetInboxCount(isRead: Bool) {

//        

//        //copy related soap request structure here

//        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetInboxCount xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><isRead>\(isRead)</isRead></GetInboxCount></soap:Body></soap:Envelope>"

//        expectedElementName = "GetInboxCountResponse"

//        //use related webservice url here

//        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

//    }

    

    func ChangeMessageIsRead(msgIds: String) {

        let sendingElementName = "ChangeMessageIsRead"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><msgIds>\(msgIds)</msgIds></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    

    

    //Users API Operations

    func AddPayment(name: String, family: String, bankName: String, code: String, amount: Double, cardNumber: String) {


        let sendingElementName = "AddPayment"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><name>\(name)</name><family>\(family)</family><bankName>\(bankName)</bankName><code>\(code)</code><amount>\(amount)</amount><cardNumber>\(cardNumber)</cardNumber></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func AddUser(productId: Int, descriptions: String, mobileNumber: String, emailAddress: String, nationalCode: String, name: String, family: String, corporation: String, phone: String, fax: String, address: String, postalCode: String, certificateNumber: String) {


        let sendingElementName = "AddUser"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><productId>\(productId)</productId><descriptions>\(descriptions)</descriptions><mobileNumber>\(mobileNumber)</mobileNumber><emailAddress>\(emailAddress)</emailAddress><nationalCode>\(nationalCode)</nationalCode><name>\(name)</name><family>\(family)</family><corporation>\(corporation)</corporation><phone>\(phone)</phone><fax>\(fax)</fax><address>\(address)</address><postalCode>\(postalCode)</postalCode><certificateNumber>\(certificateNumber)</certificateNumber></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func AddUserComplete(productId: Int, descriptions: String, mobileNumber: String, emailAddress: String, nationalCode: String, name: String, family: String, corporation: String, phone: String, fax: String, address: String, postalCode: String, certificateNumber: String, country: Int, province: Int, city: Int, howFindUs: String, commercialCode: String, saleId: String, recommanderId: String) {


        let sendingElementName = "AddUserComplete"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><productId>\(productId)</productId><descriptions>\(descriptions)</descriptions><mobileNumber>\(mobileNumber)</mobileNumber><emailAddress>\(emailAddress)</emailAddress><nationalCode>\(nationalCode)</nationalCode><name>\(name)</name><family>\(family)</family><corporation>\(corporation)</corporation><phone>\(phone)</phone><fax>\(fax)</fax><address>\(address)</address><postalCode>\(postalCode)</postalCode><certificateNumber>\(certificateNumber)</certificateNumber><country>\(country)</country><province>\(province)</province><city>\(city)</city><howFindUs>\(howFindUs)</howFindUs><commercialCode>\(commercialCode)</commercialCode><saleId>\(saleId)</saleId><recommanderId>\(recommanderId)</recommanderId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func AddUserWithLocation(productId: Int, descriptions: String, mobileNumber: String, emailAddress: String, nationalCode: String, name: String, family: String, corporation: String, phone: String, fax: String, address: String, postalCode: String, certificateNumber: String, country: Int, province: Int, city: Int) {


        let sendingElementName = "AddUserWithLocation"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><productId>\(productId)</productId><descriptions>\(descriptions)</descriptions><mobileNumber>\(mobileNumber)</mobileNumber><emailAddress>\(emailAddress)</emailAddress><nationalCode>\(nationalCode)</nationalCode><name>\(name)</name><family>\(family)</family><corporation>\(corporation)</corporation><phone>\(phone)</phone><fax>\(fax)</fax><address>\(address)</address><postalCode>\(postalCode)</postalCode><certificateNumber>\(certificateNumber)</certificateNumber><country>\(country)</country><province>\(province)</province><city>\(city)</city></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func AddUserWithMobileNumber(productId: Int, mobileNumber: String, firstName: String, lastName: String, email: String) {


        let sendingElementName = "AddUserWithMobileNumber"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><productId>\(productId)</productId><mobileNumber>\(mobileNumber)</mobileNumber><firstName>\(firstName)</firstName><lastName>\(lastName)</lastName><email>\(email)</email></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func AddUserWithUserNameAndPass(targetUserName: String, targetUserPassword: String, productId: Int, descriptions: String, mobileNumber: String, emailAddress: String, nationalCode: String, name: String, family: String, corporation: String, phone: String, fax: String, address: String, postalCode: String, certificateNumber: String) {


        let sendingElementName = "AddUserWithUserNameAndPass"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><targetUserName>\(targetUserName)</targetUserName><targetUserPassword>\(targetUserPassword)</targetUserPassword><productId>\(productId)</productId><descriptions>\(descriptions)</descriptions><mobileNumber>\(mobileNumber)</mobileNumber><emailAddress>\(emailAddress)</emailAddress><nationalCode>\(nationalCode)</nationalCode><name>\(name)</name><family>\(family)</family><corporation>\(corporation)</corporation><phone>\(phone)</phone><fax>\(fax)</fax><address>\(address)</address><postalCode>\(postalCode)</postalCode><certificateNumber>\(certificateNumber)</certificateNumber></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func AuthenticateUser() {

        let sendingElementName = "AuthenticateUser"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func ChangeUserCredit(amount: Double, description: String, targetUsername: String, GetTax: Bool) {


        let sendingElementName = "ChangeUserCredit"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><amount>\(amount)</amount><description>\(description)</description><targetUsername>\(targetUsername)</targetUsername><GetTax>\(GetTax)</GetTax></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func ChangeUserCredit2(amount: String, description: String, targetUsername: String, GetTax: Bool) {

        let sendingElementName = "ChangeUserCredit2"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><amount>\(amount)</amount><description>\(description)</description><targetUsername>\(targetUsername)</targetUsername><GetTax>\(GetTax)</GetTax></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func ChangeUserCreditBySeccondPass(ausername: String, seccondPassword: String, amount: Double, description: String, targetUsername: String, GetTax: Bool) {


        let sendingElementName = "ChangeUserCreditBySeccondPass"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(ausername)</username><seccondPassword>\(seccondPassword)</seccondPassword><amount>\(amount)</amount><description>\(description)</description><targetUsername>\(targetUsername)</targetUsername><GetTax>\(GetTax)</GetTax></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func DeductUserCredit(ausername: String, apassword: String, amount: Double, description: String) {

        let sendingElementName = "DeductUserCredit"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(ausername)</username><password>\(apassword)</password><amount>\(amount)</amount><description>\(description)</description></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func ForgotPassword(mobileNumber: String, emailAddress: String, targetUsername: String) {

        let sendingElementName = "ForgotPassword"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><mobileNumber>\(mobileNumber)</mobileNumber><emailAddress>\(emailAddress)</emailAddress><targetUsername>\(targetUsername)</targetUsername></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetCities(provinceId: Int) {

        let sendingElementName = "GetCities"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><provinceId>\(provinceId)</provinceId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetEnExpireDate() {

        let sendingElementName = "GetEnExpireDate"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetExpireDate() {

        let sendingElementName = "GetExpireDate"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetProvinces() {

        let sendingElementName = "GetProvinces"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetUserBasePrice(targetUsername: String) {

        let sendingElementName = "GetUserBasePrice"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><targetUsername>\(targetUsername)</targetUsername></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetUserByUserID(pass: String, userId: Int) {

        let sendingElementName = "GetUserByUserID"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><pass>\(pass)</pass><userId>\(userId)</userId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetUserCredit(targetUsername: String) {

        let sendingElementName = "GetUserCredit"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><targetUsername>\(targetUsername)</targetUsername></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetUserCreditBySecondPass(secondPassword: String, targetUsername: String) {

        let sendingElementName = "GetUserCreditBySecondPass"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><secondPassword>\(secondPassword)</secondPassword><targetUsername>\(targetUsername)</targetUsername></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetUserDetails(targetUsername: String) {

        let sendingElementName = "GetUserDetails"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><targetUsername>\(targetUsername)</targetUsername></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetUserIsExist(targetUsername: String) {

        let sendingElementName = "GetUserIsExist"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><targetUsername>\(targetUsername)</targetUsername></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetUserNumbers() {

        let sendingElementName = "GetUserNumbers"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetUserTransactions(targetUsername: String, creditType: String, dateFrom: Date, dateTo: Date, keyword: String) {

        let sendingElementName = "GetUserTransactions"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><targetUsername>\(targetUsername)</targetUsername><creditType>\(creditType)</creditType><dateFrom>\(dateFrom)</dateFrom><dateTo>\(dateTo)</dateTo><keyword>\(keyword)</keyword></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetUserWallet() {

        let sendingElementName = "GetUserWallet"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetUserWalletTransaction(dateFrom: Date, dateTo: Date, count: Int, startIndex: Int, payType: String, PayLoc: String) {


        let sendingElementName = "GetUserWalletTransaction"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><dateFrom>\(dateFrom)</dateFrom><dateTo>\(dateTo)</dateTo><count>\(count)</count><startIndex>\(startIndex)</startIndex><payType>\(payType)</payType><payLoc>\(PayLoc)</payLoc></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetUsers() {

        let sendingElementName = "GetUsers"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func HasFilter(text: String) {

        let sendingElementName = "HasFilter"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><text>\(text)</text></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func RemoveUser(targetUsername: String) {

        let sendingElementName = "RemoveUser"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><targetUsername>\(targetUsername)</targetUsername></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func RevivalUser(targetUsername: String) {

        let sendingElementName = "RevivalUser"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><targetUserName>\(targetUsername)</targetUserName></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    //Contact API Operations

    func AddContact(groupIds: String, firstname: String, lastname: String, nickname: String, corporation: String, mobilenumber: String, phone: String, fax: String, birthdate: Date, email: String, gender: UInt8, province: Int, city: Int, address: String, postalCode: String, additionaldate: Date, additionaltext: String, descriptions: String) {

        let sendingElementName = "AddContact"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><groupIds>\(groupIds)</groupIds><firstname>\(firstname)</firstname><lastname>\(lastname)</lastname><nickname>\(nickname)</nickname><corporation>\(corporation)</corporation><mobilenumber>\(mobilenumber)</mobilenumber><phone>\(phone)</phone><fax>\(fax)</fax><birthdate>\(birthdate)</birthdate><email>\(email)</email><gender>\(gender)</gender><province>\(province)</province><city>\(city)</city><address>\(address)</address><postalCode>\(postalCode)</postalCode><additionaldate>\(additionaldate)</additionaldate><additionaltext>\(additionaltext)</additionaltext><descriptions>\(descriptions)</descriptions></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func AddContactEvents(contactId: Int, eventName: String, eventType: UInt8, eventDate: Date) {

        let sendingElementName = "AddContactEvents"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><contactId>\(contactId)</contactId><eventName>\(eventName)</eventName><eventDate>\(eventDate)</eventDate><eventType>\(eventType)</eventType></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func AddGroup(groupName: String, Descriptions: String, showToChilds: Bool) {

        let sendingElementName = "AddGroup"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><groupName>\(groupName)</groupName><Descriptions>\(Descriptions)</Descriptions><showToChilds>\(showToChilds)</showToChilds></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func ChangeContact(contactId: Int, mobilenumber: String, firstname: String, lastname: String, nickname: String, corporation: String, phone: String, fax: String, email: String, gender: UInt8, province: Int, city: Int, address: String, postalCode: String, additionaltext: String, descriptions: String, contactStatus: Int) {


        let sendingElementName = "ChangeContact"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><contactId>\(contactId)</contactId><mobilenumber>\(mobilenumber)</mobilenumber><firstname>\(firstname)</firstname><lastName>\(lastname)</lastname><nickname>\(nickname)</nickname><corporation>\(corporation)</corporation><phone>\(phone)</phone><fax>\(fax)</fax><email>\(email)</email><gender>\(gender)</gender><province>\(province)</province><city>\(city)</city><address>\(address)</address><postalCode>\(postalCode)</postalCode><additionaltext>\(additionaltext)</additionaltext><descriptions>\(descriptions)</descriptions><contactStatus>\(contactStatus)</contactStatus></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func ChangeGroup(groupId: Int, groupName: String, Descriptions: String, showToChilds: Bool, groupStatus: UInt8) {

        let sendingElementName = "ChangeGroup"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><groupId>\(groupId)</groupId><groupName>\(groupName)</groupName><Descriptions>\(Descriptions)</Descriptions><showToChilds>\(showToChilds)</showToChilds><groupStatus>\(groupStatus)</groupStatus></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func CheckMobileExistInContact(mobileNumber: String) {

        let sendingElementName = "CheckMobileExistInContact"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><mobileNumber>\(mobileNumber)</mobileNumber></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func GetContactEvents(contactId: Int) {

        let sendingElementName = "GetContactEvents"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><contactId>\(contactId)</contactId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func GetContacts(groupId: Int, keyword: String, from: Int, count: Int) {

        let sendingElementName = "GetContacts"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><groupId>\(groupId)</groupId><keyword>\(keyword)</keyword><from>\(from)</from><count>\(count)</count></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func GetContactsByID(contactId: Int, status: Int) {

        let sendingElementName = "GetContactsByID"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><contactId>\(contactId)</contactId><status>\(status)</status></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func GetGroups() {

        let sendingElementName = "GetGroups"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func MergeGroups(originGroupId: Int, destinationGroupId: Int, deleteOriginGroup: Bool) {


        let sendingElementName = "MergeGroups"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><originGroupId>\(originGroupId)</originGroupId><destinationGroupId>\(destinationGroupId)</destinationGroupId><deleteOriginGroup>\(deleteOriginGroup)</deleteOriginGroup></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func RemoveContact(mobilenumber: String) {

        let sendingElementName = "RemoveContact"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><mobilenumber>\(mobilenumber)</mobilenumber></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func RemoveContactByContactID(contactId: Int) {

        let sendingElementName = "RemoveContactByContactID"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><contactId>\(contactId)</contactId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func RemoveGroup(groupId: Int) {

        let sendingElementName = "RemoveGroup"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><groupId>\(groupId)</groupId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    

    //ACtions API Operations

    func AddBranch(branchName: String, owner: Int) {


        let sendingElementName = "AddBranch"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><branchName>\(branchName)</branchName><owner>\(owner)</owner></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func AddBulk(from: String, branch: Int, bulkType: UInt8, title: String, message: String, rangeFrom: String, rangeTo: String, DateToSend: Date, requestCount: Int, rowFrom: Int) {


        let sendingElementName = "AddBulk"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><from>\(from)</from><branch>\(branch)</branch><bulkType>\(bulkType)</bulkType><title>\(title)</title><message>\(message)</message><rangeFrom>\(rangeFrom)</rangeFrom><rangeTo>\(rangeTo)</rangeTo><DateToSend>\(DateToSend)</DateToSend><requestCount>\(requestCount)</requestCount><rowFrom>\(rowFrom)</rowFrom></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func AddBulk2(from: String, branch: Int, bulkType: UInt8, title: String, message: String, rangeFrom: String, rangeTo: String, DateToSend: String, requestCount: Int, rowFrom: Int) {


        let sendingElementName = "AddBulk2"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><from>\(from)</from><branch>\(branch)</branch><bulkType>\(bulkType)</bulkType><title>\(title)</title><message>\(message)</message><rangeFrom>\(rangeFrom)</rangeFrom><rangeTo>\(rangeTo)</rangeTo><DateToSend>\(DateToSend)</DateToSend><requestCount>\(requestCount)</requestCount><rowFrom>\(rowFrom)</rowFrom></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func AddNewBulk(from: String, branch: Int, bulkType: UInt8, title: String, message: String, rangeFrom: String, rangeTo: String, DateToSend: Date, requestCount: Int, rowFrom: Int) {


        let sendingElementName = "AddNewBulk"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><from>\(from)</from><branch>\(branch)</branch><bulkType>\(bulkType)</bulkType><title>\(title)</title><message>\(message)</message><rangeFrom>\(rangeFrom)</rangeFrom><rangeTo>\(rangeTo)</rangeTo><DateToSend>\(DateToSend)</DateToSend><requestCount>\(requestCount)</requestCount><rowFrom>\(rowFrom)</rowFrom></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func AddNumber(branchId: Int, mobileNumbers: [String]) {

        

        let stringSplitter = "</string><string>"

        let _mobileNumbers = "<string>" + mobileNumbers.joined(separator: stringSplitter) + "</string>"

        let sendingElementName = "AddNumber"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><branchId>\(branchId)</branchId><mobileNumbers>\(_mobileNumbers)</mobileNumbers></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func GetBranchs(owner: Int) {

        let sendingElementName = "GetBranchs"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><owner>\(owner)</owner></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func GetBulk() {

        let sendingElementName = "GetBulk"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func GetBulkCount(branch: Int, rangeFrom: String, rangeTo: String) {

        let sendingElementName = "GetBulkCount"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><branch>\(branch)</branch><rangeFrom>\(rangeFrom)</rangeFrom><rangeTo>\(rangeTo)</rangeTo></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func GetBulkReceptions(bulkId: Int, fromRows: Int) {

        let sendingElementName = "GetBulkReceptions"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><bulkId>\(bulkId)</bulkId><fromRows>\(fromRows)</fromRows></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func GetBulkStatus(bulkId: Int, sent: Int, failed: Int, status: UInt8) {

        let sendingElementName = "GetBulkStatus"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><bulkId>\(bulkId)</bulkId><sent>\(sent)</sent><failed>\(failed)</failed><status>\(status)</status></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func GetMessagesReceptions(msgId: Int64, fromRows: Int) {

        let sendingElementName = "GetMessagesReceptions"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><msgId>\(msgId)</msgId><fromRows>\(fromRows)</fromRows></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func GetMobileCount(branch: Int, rangeFrom: String, rangeTo: String) {

        let sendingElementName = "GetMobileCount"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><branch>\(branch)</branch><rangeFrom>\(rangeFrom)</rangeFrom><rangeTo>\(rangeTo)</rangeTo></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func GetSendBulk() {

        let sendingElementName = "GetSendBulk"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func GetTodaySent() {

        let sendingElementName = "GetTodaySent"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func GetTotalSent() {

        let sendingElementName = "GetTotalSent"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func RemoveBranch(branchId: Int) {

        let sendingElementName = "RemoveBranch"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><branchId>\(branchId)</branchId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func RemoveBulk(bulkId: Int) {

        let sendingElementName = "RemoveBulk"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><bulkId>\(bulkId)</bulkId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func SendMultipleSMS(to: [String], from: String, text: [String], isflash: Bool, udh: String, recId: [Int64], status: String) {

        let recidAsStringArray = recId.map { String($0) }

        

        let stringSplitter = "</string><string>"

        let longSplitter = "</long><long>"

        let _to = "<string>" + to.joined(separator: stringSplitter) + "</string>"

        let _text = "<string>" + text.joined(separator: stringSplitter) + "</string>"

        let _recId = "<long>" + recidAsStringArray.joined(separator: longSplitter) + "</long>"

        let sendingElementName = "SendMultipleSMS"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(_to)</to><from>\(from)</from><text>\(_text)</text><isflash>\(isflash)</isflash><udh>\(udh)</udh><recId>\(_recId)</recId><status>\(status)</status></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func SendMultipleSMS2(to: [String], from: [String], text: [String], isflash: Bool, udh: String, recId: [Int64], status: String) {

        let recidAsStringArray = recId.map { String($0) }

        

        let stringSplitter = "</string><string>"

        let longSplitter = "</long><long>"

        let _to = "<string>" + to.joined(separator: stringSplitter) + "</string>"

        let _text = "<string>" + text.joined(separator: stringSplitter) + "</string>"

        let _from = "<string>" + from.joined(separator: stringSplitter) + "</string>"

        let _recId = "<long>" + recidAsStringArray.joined(separator: longSplitter) + "</long>"

        let sendingElementName = "SendMultipleSMS2"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(_to)</to><from>\(_from)</from><text>\(_text)</text><isflash>\(isflash)</isflash><udh>\(udh)</udh><recId>\(_recId)</recId><status>\(status)</status></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func UpdateBulkDelivery(bulkId: Int) {

        let sendingElementName = "UpdateBulkDelivery"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><bulkId>\(bulkId)</bulkId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    

    //Schedule API Operations

    func AddMultipleSchedule(to: [String], from: String, text: [String], isflash: Bool, scheduleDateTime: [Date], period: String) {

        let dateStringArray = scheduleDateTime.map { dateToString(date: $0, format: "YY/MM/dd") }

        

        let stringSplitter = "</string><string>"

        let dateSplitter = "</dateTime><dateTime>"

        let _to = "<string>" + to.joined(separator: stringSplitter) + "</string>"

        let _text = "<string>" + text.joined(separator: stringSplitter) + "</string>"

        let _schDates = "<dateTime>" + dateStringArray.joined(separator: dateSplitter) + "</dateTime>"

        let sendingElementName = "AddMultipleSchedule"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(_to)</to><from>\(from)</from><text>\(_text)</text><isflash>\(isflash)</isflash><scheduleDateTime>\(_schDates)</scheduleDateTime><period>\(period)</period></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _scheduleEndpoint, message: soapMessage)

    }

    func AddNewUsance(to: String, from: String, text: String, isflash: Bool, scheduleStartDateTime: Date, countrepeat: Int, scheduleEndDateTime: Date, periodType: String) {

        let sendingElementName = "AddNewUsance"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(to)</to><from>\(from)</from><text>\(text)</text><isflash>\(isflash)</isflash><scheduleStartDateTime>\(scheduleStartDateTime)</scheduleStartDateTime><countrepeat>\(countrepeat)</countrepeat><scheduleEndDateTime>\(scheduleEndDateTime)</scheduleEndDateTime><periodType>\(periodType)</periodType></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _scheduleEndpoint, message: soapMessage)

    }

    func AddSchedule(to: String, from: String, text: String, isflash: Bool, scheduleDateTime: Date, period: String) {

        let sendingElementName = "AddSchedule"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(to)</to><from>\(from)</from><text>\(text)</text><isflash>\(isflash)</isflash><scheduleDateTime>\(scheduleDateTime)</scheduleDateTime><period>\(period)</period></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _scheduleEndpoint, message: soapMessage)

    }

    func AddUsance(to: String, from: String, text: String, isflash: Bool, scheduleStartDateTime: Date, repeatAfterDays: Int, scheduleEndDateTime: Date) {

        let sendingElementName = "AddUsance"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(to)</to><from>\(from)</from><text>\(text)</text><isflash>\(isflash)</isflash><scheduleStartDateTime>\(scheduleStartDateTime)</scheduleStartDateTime><repeatAfterDays>\(repeatAfterDays)</repeatAfterDays><scheduleEndDateTime>\(scheduleEndDateTime)</scheduleEndDateTime></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _scheduleEndpoint, message: soapMessage)

    }

    func GetScheduleStatus(scheduleId: Int) {

        let sendingElementName = "GetScheduleStatus"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><scheduleId>\(scheduleId)</scheduleId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _scheduleEndpoint, message: soapMessage)

    }

    func RemoveSchedule(scheduleId: Int) {

        let sendingElementName = "RemoveSchedule"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><scheduleId>\(scheduleId)</scheduleId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _scheduleEndpoint, message: soapMessage)

    }

    func RemoveScheduleList(scheduleIdList: [Int]) {

        let listAsStringArray = scheduleIdList.map { String($0) }

        let intSplitter = "</int><int>"

        let _list = "<int>" + listAsStringArray.joined(separator: intSplitter) + "</int>"

        let sendingElementName = "RemoveScheduleList"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><scheduleIdList>\(_list)</scheduleIdList></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _scheduleEndpoint, message: soapMessage)

    }

    //Voice API Operations
    
    func GetSendSMSWithSpeechTextStatus(recId: Int) {

        let sendingElementName = "GetSendSMSWithSpeechTextStatus"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><recId>\(recId)</recId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _voiceEndpoint, message: soapMessage)
    }

    func SendBulkSpeechText(title: String, body: String, receivers: String, DateToSend: String, repeatCount: Int) {

        let sendingElementName = "SendBulkSpeechText"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><title>\(title)</title><body>\(body)</body><receivers>\(receivers)</receivers><DateToSend>\(DateToSend)</DateToSend><repeatCount>\(repeatCount)</repeatCount></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _voiceEndpoint, message: soapMessage)
    }

    func SendBulkVoiceSMS(title: String, voiceFileId: Int, receivers: String, DateToSend: String, repeatCount: Int) {

        let sendingElementName = "SendBulkVoiceSMS"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><title>\(title)</title><voiceFileId>\(voiceFileId)</voiceFileId><receivers>\(receivers)</receivers><DateToSend>\(DateToSend)</DateToSend><repeatCount>\(repeatCount)</repeatCount></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _voiceEndpoint, message: soapMessage)
    }


    func SendSMSWithSpeechText(smsBody: String, speechBody: String, from: String, to: String) {

        let sendingElementName = "SendSMSWithSpeechText"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><smsBody>\(smsBody)</smsBody><speechBody>\(speechBody)</speechBody><from>\(from)</from><to>\(to)</to></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _voiceEndpoint, message: soapMessage)
    } 

    func SendSMSWithSpeechTextBySchduleDate(smsBody: String, speechBody: String, from: String, to: String, scheduleDate: Date) {

        let sendingElementName = "SendSMSWithSpeechTextBySchduleDate"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><smsBody>\(smsBody)</smsBody><speechBody>\(speechBody)</speechBody><from>\(from)</from><to>\(to)</to><scheduleDate>\(scheduleDate)</scheduleDate></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _voiceEndpoint, message: soapMessage)
    }  

    func UploadVoiceFile(title: String, base64StringFile: String) {

        let sendingElementName = "UploadVoiceFile"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><title>\(title)</title><base64StringFile>\(base64StringFile)</base64StringFile></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = sendingElementName + "Response"

        initAndSendRequest(endpoint: _voiceEndpoint, message: soapMessage)
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

    

    func dateToString(date: Date, format: String) -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = format

        return dateFormatter.string(from: date)

    }
}
