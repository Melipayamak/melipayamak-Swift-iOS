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

    

    let _sendEndpoint = "http://api.payamak-panel.com/post/send.asmx"

    let _receiveEndpoint = "http://api.payamak-panel.com/post/receive.asmx"

    let _usersEndpoint = "http://api.payamak-panel.com/post/Users.asmx"

    let _contactsEndpoint = "http://api.payamak-panel.com/post/contacts.asmx"

    let _actionsEndpoint = "http://api.payamak-panel.com/post/actions.asmx"

    let _scheduleEndpoint = "http://api.payamak-panel.com/post/Schedule.asmx"

    

    

    

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

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><SendSimpleSMS2 xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(to)</to><from>\(from)</from><text>\(msg)</text><isflash>\(isFlash)</isflash></SendSimpleSMS2></soap:Body></soap:Envelope>"

        expectedElementName = "SendSimpleSMS2Response"

        //use related webservice url here

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func SendSimpleSMS(to: [String], from: String, msg: String, isFlash: Bool) {

        //prepare arrays to use in soap request

        

        let stringSplitter = "</string><string>"

        let _to = "<string>" + to.joined(separator: stringSplitter) + "</string>"

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><SendSimpleSMS xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(_to)</to><from>\(from)</from><text>\(msg)</text><isflash>\(isFlash)</isflash></SendSimpleSMS></soap:Body></soap:Envelope>"

        expectedElementName = "SendSimpleSMSResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func SendSms(to: [String], from: String, msg: String, isFlash: Bool, udh: String, recid: [Int64]) {

        //prepare arrays to use in soap request

        let recidAsStringArray = recid.map { String($0) }

        let longSplitter = "</long><long>"

        let stringSplitter = "</string><string>"

        let _to = "<string>" + to.joined(separator: stringSplitter) + "</string>"

        let _recid = "<long>" + recidAsStringArray.joined(separator: longSplitter) + "</long>"

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><SendSms xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(_to)</to><from>\(from)</from><text>\(msg)</text><isflash>\(isFlash)</isflash><udh>\(udh)</udh><recId>\(_recid)</recId><status></status></SendSms></soap:Body></soap:Envelope>"

        expectedElementName = "SendSmsResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func SendWithDomain(to: String, from: String, msg: String, isFlash: Bool, domain: String) {

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><SendWithDomain xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(to)</to><from>\(from)</from><text>\(msg)</text><isflash>\(isFlash)</isflash><domainName>\(domain)</domainName></SendWithDomain></soap:Body></soap:Envelope>"

        expectedElementName = "SendWithDomainResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func getMessages(location: Int, from: String, index: Int, count: Int) {

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><getMessages xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><location>\(location)</location><from>\(from)</from><index>\(index)</index><count>\(count)</count></getMessages></soap:Body></soap:Envelope>"

        expectedElementName = "getMessagesResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func GetSmsPrice(irancellCount: Int, mtnCount: Int, from: String, text: String) {

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetSmsPrice xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><irancellCount>\(irancellCount)</irancellCount><mtnCount>\(mtnCount)</mtnCount><from>\(from)</from><text>\(text)</text></GetSmsPrice></soap:Body></soap:Envelope>"

        expectedElementName = "GetSmsPriceResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func GetMultiDelivery2(recId: String) {

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetMultiDelivery2 xmlns='http://tempuri.org/'><recId>\(recId)</recId></GetMultiDelivery2></soap:Body></soap:Envelope>"

        expectedElementName = "GetMultiDelivery2Response"

        //use related webservice url here

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func GetMultiDelivery(recId: String) {

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetMultiDelivery xmlns='http://tempuri.org/'><recId>\(recId)</recId></GetMultiDelivery></soap:Body></soap:Envelope>"

        expectedElementName = "GetMultiDeliveryResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func GetInboxCount(isRead: Bool) {

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetInboxCount xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><isRead>\(isRead)</isRead></GetInboxCount></soap:Body></soap:Envelope>"

        expectedElementName = "GetInboxCountResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func GetDelivery2(recId: String) {

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetDelivery2 xmlns='http://tempuri.org/'><recId>\(recId)</recId></GetDelivery2></soap:Body></soap:Envelope>"

        expectedElementName = "GetDelivery2Response"

        //use related webservice url here

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func GetDelivery(recId: Int64) {

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetDelivery xmlns='http://tempuri.org/'><recId>\(recId)</recId></GetDelivery></soap:Body></soap:Envelope>"

        expectedElementName = "GetDeliveryResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func GetDeliveries3(recIds: [String]) {

        

        let stringSplitter = "</string><string>"

        let _recids = "<string>" + recIds.joined(separator: stringSplitter) + "</string>"

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetDeliveries3 xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><recId>\(_recids)</recId></GetDeliveries3></soap:Body></soap:Envelope>"

        expectedElementName = "GetDeliveries3Response"

        //use related webservice url here

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func GetDeliveries2(recId: String) {

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetDeliveries2 xmlns='http://tempuri.org/'><recId>\(recId)</recId></GetDeliveries2></soap:Body></soap:Envelope>"

        expectedElementName = "GetDeliveries2Response"

        //use related webservice url here

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func GetDeliveries(recIds: [Int64]) {

        

        let recidAsStringArray = recIds.map { String($0) }

        let longSplitter = "</long><long>"

        let _recids = "<long>" + recidAsStringArray.joined(separator: longSplitter) + "</long>"

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetDeliveries xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><recIds>\(_recids)</recIds></GetDeliveries></soap:Body></soap:Envelope>"

        expectedElementName = "GetDeliveriesResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    func GetCredit() {

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetCredit xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></GetCredit></soap:Body></soap:Envelope>"

        expectedElementName = "GetCreditResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _sendEndpoint, message: soapMessage)

    }

    

    //Receive API Operations

    func RemoveMessages2(location: Int, msgIds: String) {

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><RemoveMessages2 xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><location>\(location)</location><msgIds>\(msgIds)</msgIds></RemoveMessages2></soap:Body></soap:Envelope>"

        expectedElementName = "RemoveMessages2Response"

        //use related webservice url here

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    //use Received or Sent or Removed or Deleted for location in the next method

    func RemoveMessages(location: String, msgIds: String) {

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><RemoveMessages xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><location>\(location)</location><msgIds>\(msgIds)</msgIds></RemoveMessages></soap:Body></soap:Envelope>"

        expectedElementName = "RemoveMessagesResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    

    func GetUsersMessagesByDate(location: Int, from: String, index: Int, count: Int, dateFrom: Date, dateTo: Date) {

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetUsersMessagesByDate xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><location>\(location)</location><from>\(from)</from><index>\(index)</index><count>\(count)</count><dateFrom>\(dateFrom)</dateFrom><dateTo>\(dateTo)</dateTo></GetUsersMessagesByDate></soap:Body></soap:Envelope>"

        expectedElementName = "GetUsersMessagesByDateResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    

    func GetOutBoxCount() {

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetOutBoxCount xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></GetOutBoxCount></soap:Body></soap:Envelope>"

        expectedElementName = "GetOutBoxCountResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    

    func GetMessagesWithChangeIsRead(location: Int, from: String, index: Int, count: Int, isRead: Bool, changeIsRead: Bool) {

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetMessagesWithChangeIsRead xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><location>\(location)</location><from>\(from)</from><index>\(index)</index><count>\(count)</count><isRead>\(isRead)</isRead><changeIsRead>\(changeIsRead)</changeIsRead></GetMessagesWithChangeIsRead></soap:Body></soap:Envelope>"

        expectedElementName = "GetMessagesWithChangeIsReadResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    

    func GetMessagesReceptions(msgId: Int, fromRows: Int) {

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetMessagesReceptions xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><msgId>\(msgId)</msgId><fromRows>\(fromRows)</fromRows></GetMessagesReceptions></soap:Body></soap:Envelope>"

        expectedElementName = "GetMessagesReceptionsResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    

    func GetMessagesFilterByDate(location: Int, from: String, index: Int, count: Int, dateFrom: Date, dateTo: Date, isRead: Bool) {

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetMessagesFilterByDate xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><location>\(location)</location><from>\(from)</from><index>\(index)</index><count>\(count)</count><dateFrom>\(dateFrom)</dateFrom><dateTo>\(dateTo)</dateTo><isRead>\(isRead)</isRead></GetMessagesFilterByDate></soap:Body></soap:Envelope>"

        expectedElementName = "GetMessagesFilterByDateResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    

    func GetMessagesByDate(location: Int, from: String, index: Int, count: Int, dateFrom: Date, dateTo: Date) {

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetMessagesByDate xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><location>\(location)</location><from>\(from)</from><index>\(index)</index><count>\(count)</count><dateFrom>\(dateFrom)</dateFrom><dateTo>\(dateTo)</dateTo></GetMessagesByDate></soap:Body></soap:Envelope>"

        expectedElementName = "GetMessagesByDateResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    

    func GetMessagesAfterIDJson(location: Int, from: String, count: Int, msgId: Int) {

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetMessagesAfterIDJson xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><location>\(location)</location><from>\(from)</from><count>\(count)</count><msgId>\(msgId)</msgId></GetMessagesAfterIDJson></soap:Body></soap:Envelope>"

        expectedElementName = "GetMessagesAfterIDJsonResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    

    func GetMessagesAfterID(location: Int, from: String, count: Int, msgId: Int) {

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetMessagesAfterID xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><location>\(location)</location><from>\(from)</from><count>\(count)</count><msgId>\(msgId)</msgId></GetMessagesAfterID></soap:Body></soap:Envelope>"

        expectedElementName = "GetMessagesAfterIDResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    

    func GetMessages(location: Int, from: String, index: Int, count: Int) {

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetMessages xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><location>\(location)</location><from>\(from)</from><index>\(index)</index><count>\(count)</count></GetMessages></soap:Body></soap:Envelope>"

        expectedElementName = "GetMessagesResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    

    func GetMessageStr(location: Int, from: String, index: Int, count: Int) {

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetMessageStr xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><location>\(location)</location><from>\(from)</from><index>\(index)</index><count>\(count)</count></GetMessageStr></soap:Body></soap:Envelope>"

        expectedElementName = "GetMessageStrResponse"

        //use related webservice url here

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

        

        //copy related soap request structure here

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><ChangeMessageIsRead xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><msgIds>\(msgIds)</msgIds></ChangeMessageIsRead></soap:Body></soap:Envelope>"

        expectedElementName = "ChangeMessageIsReadResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _receiveEndpoint, message: soapMessage)

    }

    

    

    //Users API Operations

    func AddPayment(name: String, family: String, bankName: String, code: String, amount: Double, cardNumber: String) {

        

        //copy related soap request structure here

        let sendingElementName = "AddPayment"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><name>\(name)</name><family>\(family)</family><bankName>\(bankName)</bankName><code>\(code)</code><amount>\(amount)</amount><cardNumber>\(cardNumber)</cardNumber></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "AddPaymentResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func AddUser(productId: Int, descriptions: String, mobileNumber: String, emailAddress: String, nationalCode: String, name: String, family: String, corporation: String, phone: String, fax: String, address: String, postalCode: String, certificateNumber: String) {

        

        //copy related soap request structure here

        let sendingElementName = "AddUser"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><productId>\(productId)</productId><descriptions>\(descriptions)</descriptions><mobileNumber>\(mobileNumber)</mobileNumber><emailAddress>\(emailAddress)</emailAddress><nationalCode>\(nationalCode)</nationalCode><name>\(name)</name><family>\(family)</family><corporation>\(corporation)</corporation><phone>\(phone)</phone><fax>\(fax)</fax><address>\(address)</address><postalCode>\(postalCode)</postalCode><certificateNumber>\(certificateNumber)</certificateNumber></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "AddUserResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func AddUserComplete(productId: Int, descriptions: String, mobileNumber: String, emailAddress: String, nationalCode: String, name: String, family: String, corporation: String, phone: String, fax: String, address: String, postalCode: String, certificateNumber: String, country: Int, province: Int, city: Int, howFindUs: String, commercialCode: String, saleId: String, recommanderId: String) {

        

        //copy related soap request structure here

        let sendingElementName = "AddUserComplete"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><productId>\(productId)</productId><descriptions>\(descriptions)</descriptions><mobileNumber>\(mobileNumber)</mobileNumber><emailAddress>\(emailAddress)</emailAddress><nationalCode>\(nationalCode)</nationalCode><name>\(name)</name><family>\(family)</family><corporation>\(corporation)</corporation><phone>\(phone)</phone><fax>\(fax)</fax><address>\(address)</address><postalCode>\(postalCode)</postalCode><certificateNumber>\(certificateNumber)</certificateNumber><country>\(country)</country><province>\(province)</province><city>\(city)</city><howFindUs>\(howFindUs)</howFindUs><commercialCode>\(commercialCode)</commercialCode><saleId>\(saleId)</saleId><recommanderId>\(recommanderId)</recommanderId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "AddUserCompleteResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func AddUserWithLocation(productId: Int, descriptions: String, mobileNumber: String, emailAddress: String, nationalCode: String, name: String, family: String, corporation: String, phone: String, fax: String, address: String, postalCode: String, certificateNumber: String, country: Int, province: Int, city: Int) {

        

        //copy related soap request structure here

        let sendingElementName = "AddUserWithLocation"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><productId>\(productId)</productId><descriptions>\(descriptions)</descriptions><mobileNumber>\(mobileNumber)</mobileNumber><emailAddress>\(emailAddress)</emailAddress><nationalCode>\(nationalCode)</nationalCode><name>\(name)</name><family>\(family)</family><corporation>\(corporation)</corporation><phone>\(phone)</phone><fax>\(fax)</fax><address>\(address)</address><postalCode>\(postalCode)</postalCode><certificateNumber>\(certificateNumber)</certificateNumber><country>\(country)</country><province>\(province)</province><city>\(city)</city></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "AddUserWithLocationResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func AddUserWithMobileNumber(productId: Int, mobileNumber: String, firstName: String, lastName: String, email: String) {

        

        //copy related soap request structure here

        let sendingElementName = "AddUserWithMobileNumber"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><productId>\(productId)</productId><mobileNumber>\(mobileNumber)</mobileNumber><firstName>\(firstName)</firstName><lastName>\(lastName)</lastName><email>\(email)</email></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "AddUserWithMobileNumberResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func AddUserWithUserNameAndPass(targetUserName: String, targetUserPassword: String, productId: Int, descriptions: String, mobileNumber: String, emailAddress: String, nationalCode: String, name: String, family: String, corporation: String, phone: String, fax: String, address: String, postalCode: String, certificateNumber: String) {

        

        //copy related soap request structure here

        let sendingElementName = "AddUserWithUserNameAndPass"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><targetUserName>\(targetUserName)</targetUserName><targetUserPassword>\(targetUserPassword)</targetUserPassword><productId>\(productId)</productId><descriptions>\(descriptions)</descriptions><mobileNumber>\(mobileNumber)</mobileNumber><emailAddress>\(emailAddress)</emailAddress><nationalCode>\(nationalCode)</nationalCode><name>\(name)</name><family>\(family)</family><corporation>\(corporation)</corporation><phone>\(phone)</phone><fax>\(fax)</fax><address>\(address)</address><postalCode>\(postalCode)</postalCode><certificateNumber>\(certificateNumber)</certificateNumber></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "AddUserWithUserNameAndPassResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func AuthenticateUser() {

        

        //copy related soap request structure here

        let sendingElementName = "AuthenticateUser"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "AuthenticateUserResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func ChangeUserCredit(amount: Double, description: String, targetUsername: String, GetTax: Bool) {

        

        //copy related soap request structure here

        let sendingElementName = "ChangeUserCredit"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><amount>\(amount)</amount><description>\(description)</description><targetUsername>\(targetUsername)</targetUsername><GetTax>\(GetTax)</GetTax></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "ChangeUserCreditResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func ChangeUserCredit2(amount: String, description: String, targetUsername: String, GetTax: Bool) {

        

        //copy related soap request structure here

        let sendingElementName = "ChangeUserCredit2"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><amount>\(amount)</amount><description>\(description)</description><targetUsername>\(targetUsername)</targetUsername><GetTax>\(GetTax)</GetTax></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "ChangeUserCredit2Response"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func ChangeUserCreditBySeccondPass(ausername: String, seccondPassword: String, amount: Double, description: String, targetUsername: String, GetTax: Bool) {

        

        //copy related soap request structure here

        let sendingElementName = "ChangeUserCreditBySeccondPass"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(ausername)</username><seccondPassword>\(seccondPassword)</seccondPassword><amount>\(amount)</amount><description>\(description)</description><targetUsername>\(targetUsername)</targetUsername><GetTax>\(GetTax)</GetTax></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "ChangeUserCreditBySeccondPassResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func DeductUserCredit(ausername: String, apassword: String, amount: Double, description: String) {

        

        //copy related soap request structure here

        let sendingElementName = "DeductUserCredit"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(ausername)</username><password>\(apassword)</password><amount>\(amount)</amount><description>\(description)</description></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "DeductUserCreditResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func ForgotPassword(mobileNumber: String, emailAddress: String, targetUsername: String) {

        

        //copy related soap request structure here

        let sendingElementName = "ForgotPassword"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><mobileNumber>\(mobileNumber)</mobileNumber><emailAddress>\(emailAddress)</emailAddress><targetUsername>\(targetUsername)</targetUsername></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "ForgotPasswordResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetCities(provinceId: Int) {

        

        //copy related soap request structure here

        let sendingElementName = "GetCities"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><provinceId>\(provinceId)</provinceId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetCitiesResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetEnExpireDate() {

        

        //copy related soap request structure here

        let sendingElementName = "GetEnExpireDate"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetEnExpireDateResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetExpireDate() {

        

        //copy related soap request structure here

        let sendingElementName = "GetExpireDate"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetExpireDateResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetProvinces() {

        

        //copy related soap request structure here

        let sendingElementName = "GetProvinces"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetProvincesResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetUserBasePrice(targetUsername: String) {

        

        //copy related soap request structure here

        let sendingElementName = "GetUserBasePrice"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><targetUsername>\(targetUsername)</targetUsername></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetUserBasePriceResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetUserByUserID(pass: String, userId: Int) {

        

        //copy related soap request structure here

        let sendingElementName = "GetUserByUserID"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><pass>\(pass)</pass><userId>\(userId)</userId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetUserByUserIDResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetUserCredit(targetUsername: String) {

        

        //copy related soap request structure here

        let sendingElementName = "GetUserCredit"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><targetUsername>\(targetUsername)</targetUsername></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetUserCreditResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetUserCreditBySecondPass(secondPassword: String, targetUsername: String) {

        

        //copy related soap request structure here

        let sendingElementName = "GetUserCreditBySecondPass"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><secondPassword>\(secondPassword)</secondPassword><targetUsername>\(targetUsername)</targetUsername></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetUserCreditBySecondPassResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetUserDetails(targetUsername: String) {

        

        //copy related soap request structure here

        let sendingElementName = "GetUserDetails"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><targetUsername>\(targetUsername)</targetUsername></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetUserDetailsResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetUserIsExist(targetUsername: String) {

        

        //copy related soap request structure here

        let sendingElementName = "GetUserIsExist"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><targetUsername>\(targetUsername)</targetUsername></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetUserIsExistResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetUserNumbers() {

        

        //copy related soap request structure here

        let sendingElementName = "GetUserNumbers"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetUserNumbersResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetUserTransactions(targetUsername: String, creditType: String, dateFrom: Date, dateTo: Date, keyword: String) {

        

        //copy related soap request structure here

        let sendingElementName = "GetUserTransactions"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><targetUsername>\(targetUsername)</targetUsername><creditType>\(creditType)</creditType><dateFrom>\(dateFrom)</dateFrom><dateTo>\(dateTo)</dateTo><keyword>\(keyword)</keyword></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetUserTransactionsResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetUserWallet() {

        

        //copy related soap request structure here

        let sendingElementName = "GetUserWallet"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetUserWalletResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetUserWalletTransaction(dateFrom: Date, dateTo: Date, count: Int, startIndex: Int, payType: String, PayLoc: String) {

        

        //copy related soap request structure here

        let sendingElementName = "GetUserWalletTransaction"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><dateFrom>\(dateFrom)</dateFrom><dateTo>\(dateTo)</dateTo><count>\(count)</count><startIndex>\(startIndex)</startIndex><payType>\(payType)</payType><payLoc>\(PayLoc)</payLoc></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetUserWalletTransactionResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func GetUsers() {

        

        //copy related soap request structure here

        let sendingElementName = "GetUsers"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetUsersResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func HasFilter(text: String) {

        

        //copy related soap request structure here

        let sendingElementName = "HasFilter"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><text>\(text)</text></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "HasFilterResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func RemoveUser(targetUsername: String) {

        

        //copy related soap request structure here

        let sendingElementName = "RemoveUser"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><targetUsername>\(targetUsername)</targetUsername></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "RemoveUserResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    func RevivalUser(targetUsername: String) {

        

        //copy related soap request structure here

        let sendingElementName = "RevivalUser"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><targetUserName>\(targetUsername)</targetUserName></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "RevivalUserResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _usersEndpoint, message: soapMessage)

    }

    //Contact API Operations

    func AddContact(groupIds: String, firstname: String, lastname: String, nickname: String, corporation: String, mobilenumber: String, phone: String, fax: String, birthdate: Date, email: String, gender: UInt8, province: Int, city: Int, address: String, postalCode: String, additionaldate: Date, additionaltext: String, descriptions: String) {

        

        //copy related soap request structure here

        let sendingElementName = "AddContact"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><groupIds>\(groupIds)</groupIds><firstname>\(firstname)</firstname><lastname>\(lastname)</lastname><nickname>\(nickname)</nickname><corporation>\(corporation)</corporation><mobilenumber>\(mobilenumber)</mobilenumber><phone>\(phone)</phone><fax>\(fax)</fax><birthdate>\(birthdate)</birthdate><email>\(email)</email><gender>\(gender)</gender><province>\(province)</province><city>\(city)</city><address>\(address)</address><postalCode>\(postalCode)</postalCode><additionaldate>\(additionaldate)</additionaldate><additionaltext>\(additionaltext)</additionaltext><descriptions>\(descriptions)</descriptions></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "AddContactResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func AddContactEvents(contactId: Int, eventName: String, eventType: UInt8, eventDate: Date) {

        

        //copy related soap request structure here

        let sendingElementName = "AddContactEvents"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><contactId>\(contactId)</contactId><eventName>\(eventName)</eventName><eventDate>\(eventDate)</eventDate><eventType>\(eventType)</eventType></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "AddContactEventsResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func AddGroup(groupName: String, Descriptions: String, showToChilds: Bool) {

        

        //copy related soap request structure here

        let sendingElementName = "AddGroup"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><groupName>\(groupName)</groupName><Descriptions>\(Descriptions)</Descriptions><showToChilds>\(showToChilds)</showToChilds></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "AddGroupResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func ChangeContact(contactId: Int, mobilenumber: String, firstname: String, lastname: String, nickname: String, corporation: String, phone: String, fax: String, email: String, gender: UInt8, province: Int, city: Int, address: String, postalCode: String, additionaltext: String, descriptions: String, contactStatus: Int) {

        

        //copy related soap request structure here

        let sendingElementName = "ChangeContact"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><contactId>\(contactId)</contactId><mobilenumber>\(mobilenumber)</mobilenumber><firstname>\(firstname)</firstname><lastName>\(lastname)</lastname><nickname>\(nickname)</nickname><corporation>\(corporation)</corporation><phone>\(phone)</phone><fax>\(fax)</fax><email>\(email)</email><gender>\(gender)</gender><province>\(province)</province><city>\(city)</city><address>\(address)</address><postalCode>\(postalCode)</postalCode><additionaltext>\(additionaltext)</additionaltext><descriptions>\(descriptions)</descriptions><contactStatus>\(contactStatus)</contactStatus></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "ChangeContactResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func ChangeGroup(groupId: Int, groupName: String, Descriptions: String, showToChilds: Bool, groupStatus: UInt8) {

        

        //copy related soap request structure here

        let sendingElementName = "ChangeGroup"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><groupId>\(groupId)</groupId><groupName>\(groupName)</groupName><Descriptions>\(Descriptions)</Descriptions><showToChilds>\(showToChilds)</showToChilds><groupStatus>\(groupStatus)</groupStatus></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "ChangeGroupResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func CheckMobileExistInContact(mobileNumber: String) {

        

        //copy related soap request structure here

        let sendingElementName = "CheckMobileExistInContact"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><mobileNumber>\(mobileNumber)</mobileNumber></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "CheckMobileExistInContactResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func GetContactEvents(contactId: Int) {

        

        //copy related soap request structure here

        let sendingElementName = "GetContactEvents"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><contactId>\(contactId)</contactId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetContactEventsResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func GetContacts(groupId: Int, keyword: String, from: Int, count: Int) {

        

        //copy related soap request structure here

        let sendingElementName = "GetContacts"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><groupId>\(groupId)</groupId><keyword>\(keyword)</keyword><from>\(from)</from><count>\(count)</count></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetContactsResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func GetContactsByID(contactId: Int, status: Int) {

        

        //copy related soap request structure here

        let sendingElementName = "GetContactsByID"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><contactId>\(contactId)</contactId><status>\(status)</status></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetContactsByIDResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func GetGroups() {

        

        //copy related soap request structure here

        let sendingElementName = "GetGroups"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetGroupsResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func MergeGroups(originGroupId: Int, destinationGroupId: Int, deleteOriginGroup: Bool) {

        

        //copy related soap request structure here

        let sendingElementName = "MergeGroups"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><originGroupId>\(originGroupId)</originGroupId><destinationGroupId>\(destinationGroupId)</destinationGroupId><deleteOriginGroup>\(deleteOriginGroup)</deleteOriginGroup></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "MergeGroupsResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func RemoveContact(mobilenumber: String) {

        

        //copy related soap request structure here

        let sendingElementName = "RemoveContact"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><mobilenumber>\(mobilenumber)</mobilenumber></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "RemoveContactResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func RemoveContactByContactID(contactId: Int) {

        

        //copy related soap request structure here

        let sendingElementName = "RemoveContactByContactID"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><contactId>\(contactId)</contactId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "RemoveContactByContactIDResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    func RemoveGroup(groupId: Int) {

        

        //copy related soap request structure here

        let sendingElementName = "RemoveGroup"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><groupId>\(groupId)</groupId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "RemoveGroupResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _contactsEndpoint, message: soapMessage)

    }

    

    //ACtions API Operations

    func AddBranch(branchName: String, owner: Int) {

        

        //copy related soap request structure here

        let sendingElementName = "AddBranch"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><branchName>\(branchName)</branchName><owner>\(owner)</owner></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "AddBranchResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func AddBulk(from: String, branch: Int, bulkType: UInt8, title: String, message: String, rangeFrom: String, rangeTo: String, DateToSend: Date, requestCount: Int, rowFrom: Int) {

        

        //copy related soap request structure here

        let sendingElementName = "AddBulk"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><from>\(from)</from><branch>\(branch)</branch><bulkType>\(bulkType)</bulkType><title>\(title)</title><message>\(message)</message><rangeFrom>\(rangeFrom)</rangeFrom><rangeTo>\(rangeTo)</rangeTo><DateToSend>\(DateToSend)</DateToSend><requestCount>\(requestCount)</requestCount><rowFrom>\(rowFrom)</rowFrom></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "AddBulkResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func AddBulk2(from: String, branch: Int, bulkType: UInt8, title: String, message: String, rangeFrom: String, rangeTo: String, DateToSend: String, requestCount: Int, rowFrom: Int) {

        

        //copy related soap request structure here

        let sendingElementName = "AddBulk2"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><from>\(from)</from><branch>\(branch)</branch><bulkType>\(bulkType)</bulkType><title>\(title)</title><message>\(message)</message><rangeFrom>\(rangeFrom)</rangeFrom><rangeTo>\(rangeTo)</rangeTo><DateToSend>\(DateToSend)</DateToSend><requestCount>\(requestCount)</requestCount><rowFrom>\(rowFrom)</rowFrom></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "AddBulk2Response"

        //use related webservice url here

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func AddNewBulk(from: String, branch: Int, bulkType: UInt8, title: String, message: String, rangeFrom: String, rangeTo: String, DateToSend: Date, requestCount: Int, rowFrom: Int) {

        

        //copy related soap request structure here

        let sendingElementName = "AddNewBulk"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><from>\(from)</from><branch>\(branch)</branch><bulkType>\(bulkType)</bulkType><title>\(title)</title><message>\(message)</message><rangeFrom>\(rangeFrom)</rangeFrom><rangeTo>\(rangeTo)</rangeTo><DateToSend>\(DateToSend)</DateToSend><requestCount>\(requestCount)</requestCount><rowFrom>\(rowFrom)</rowFrom></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "AddNewBulkResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func AddNumber(branchId: Int, mobileNumbers: [String]) {

        

        let stringSplitter = "</string><string>"

        let _mobileNumbers = "<string>" + mobileNumbers.joined(separator: stringSplitter) + "</string>"

        //copy related soap request structure here

        let sendingElementName = "AddNumber"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><branchId>\(branchId)</branchId><mobileNumbers>\(_mobileNumbers)</mobileNumbers></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "AddNumberResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func GetBranchs(owner: Int) {

        //copy related soap request structure here

        let sendingElementName = "GetBranchs"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><owner>\(owner)</owner></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetBranchsResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func GetBulk() {

        //copy related soap request structure here

        let sendingElementName = "GetBulk"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetBulkResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func GetBulkCount(branch: Int, rangeFrom: String, rangeTo: String) {

        //copy related soap request structure here

        let sendingElementName = "GetBulkCount"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><branch>\(branch)</branch><rangeFrom>\(rangeFrom)</rangeFrom><rangeTo>\(rangeTo)</rangeTo></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetBulkCountResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func GetBulkReceptions(bulkId: Int, fromRows: Int) {

        //copy related soap request structure here

        let sendingElementName = "GetBulkReceptions"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><bulkId>\(bulkId)</bulkId><fromRows>\(fromRows)</fromRows></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetBulkReceptionsResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func GetBulkStatus(bulkId: Int, sent: Int, failed: Int, status: UInt8) {

        //copy related soap request structure here

        let sendingElementName = "GetBulkStatus"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><bulkId>\(bulkId)</bulkId><sent>\(sent)</sent><failed>\(failed)</failed><status>\(status)</status></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetBulkStatusResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func GetMessagesReceptionss(msgId: Int64, fromRows: Int) {

        //copy related soap request structure here

        let sendingElementName = "GetMessagesReceptions"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><msgId>\(msgId)</msgId><fromRows>\(fromRows)</fromRows></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetMessagesReceptionsResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func GetMobileCount(branch: Int, rangeFrom: String, rangeTo: String) {

        //copy related soap request structure here

        let sendingElementName = "GetMobileCount"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><branch>\(branch)</branch><rangeFrom>\(rangeFrom)</rangeFrom><rangeTo>\(rangeTo)</rangeTo></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetMobileCountResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func GetSendBulk() {

        //copy related soap request structure here

        let sendingElementName = "GetSendBulk"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetSendBulkResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func GetTodaySent() {

        //copy related soap request structure here

        let sendingElementName = "GetTodaySent"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetTodaySentResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func GetTotalSent() {

        //copy related soap request structure here

        let sendingElementName = "GetTotalSent"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetTotalSentResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func RemoveBranch(branchId: Int) {

        //copy related soap request structure here

        let sendingElementName = "RemoveBranch"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><branchId>\(branchId)</branchId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "RemoveBranchResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func RemoveBulk(bulkId: Int) {

        //copy related soap request structure here

        let sendingElementName = "RemoveBulk"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><bulkId>\(bulkId)</bulkId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "RemoveBulkResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func SendMultipleSMS(to: [String], from: String, text: [String], isflash: Bool, udh: String, recId: [Int64], status: String) {

        let recidAsStringArray = recId.map { String($0) }

        

        let stringSplitter = "</string><string>"

        let longSplitter = "</long><long>"

        let _to = "<string>" + to.joined(separator: stringSplitter) + "</string>"

        let _text = "<string>" + text.joined(separator: stringSplitter) + "</string>"

        let _recId = "<long>" + recidAsStringArray.joined(separator: longSplitter) + "</long>"

        //copy related soap request structure here

        let sendingElementName = "SendMultipleSMS"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(_to)</to><from>\(from)</from><text>\(_text)</text><isflash>\(isflash)</isflash><udh>\(udh)</udh><recId>\(_recId)</recId><status>\(status)</status></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "SendMultipleSMSResponse"

        //use related webservice url here

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

        //copy related soap request structure here

        let sendingElementName = "SendMultipleSMS2"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(_to)</to><from>\(_from)</from><text>\(_text)</text><isflash>\(isflash)</isflash><udh>\(udh)</udh><recId>\(_recId)</recId><status>\(status)</status></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "SendMultipleSMS2Response"

        //use related webservice url here

        initAndSendRequest(endpoint: _actionsEndpoint, message: soapMessage)

    }

    func UpdateBulkDelivery(bulkId: Int) {

        //copy related soap request structure here

        let sendingElementName = "UpdateBulkDelivery"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><bulkId>\(bulkId)</bulkId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "UpdateBulkDeliveryResponse"

        //use related webservice url here

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

        //copy related soap request structure here

        let sendingElementName = "AddMultipleSchedule"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(_to)</to><from>\(from)</from><text>\(_text)</text><isflash>\(isflash)</isflash><scheduleDateTime>\(_schDates)</scheduleDateTime><period>\(period)</period></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "AddMultipleScheduleResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _scheduleEndpoint, message: soapMessage)

    }

    func AddNewUsance(to: String, from: String, text: String, isflash: Bool, scheduleStartDateTime: Date, countrepeat: Int, scheduleEndDateTime: Date, periodType: String) {

        //copy related soap request structure here

        let sendingElementName = "AddNewUsance"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(to)</to><from>\(from)</from><text>\(text)</text><isflash>\(isflash)</isflash><scheduleStartDateTime>\(scheduleStartDateTime)</scheduleStartDateTime><countrepeat>\(countrepeat)</countrepeat><periodType>\(periodType)</periodType></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "AddNewUsanceResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _scheduleEndpoint, message: soapMessage)

    }

    func AddSchedule(to: String, from: String, text: String, isflash: Bool, scheduleDateTime: Date, period: String) {

        //copy related soap request structure here

        let sendingElementName = "AddSchedule"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(to)</to><from>\(from)</from><text>\(text)</text><isflash>\(isflash)</isflash><scheduleDateTime>\(scheduleDateTime)</scheduleDateTime><period>\(period)</period></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "AddScheduleResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _scheduleEndpoint, message: soapMessage)

    }

    func AddUsance(to: String, from: String, text: String, isflash: Bool, scheduleStartDateTime: Date, repeatAfterDays: Int, scheduleEndDateTime: Date) {

        //copy related soap request structure here

        let sendingElementName = "AddUsance"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(to)</to><from>\(from)</from><text>\(text)</text><isflash>\(isflash)</isflash><scheduleStartDateTime>\(scheduleStartDateTime)</scheduleStartDateTime><repeatAfterDays>\(repeatAfterDays)</repeatAfterDays><scheduleEndDateTime>\(scheduleEndDateTime)</scheduleEndDateTime></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "AddUsanceResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _scheduleEndpoint, message: soapMessage)

    }

    func GetScheduleStatus(scheduleId: Int) {

        //copy related soap request structure here

        let sendingElementName = "GetScheduleStatus"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><scheduleId>\(scheduleId)</scheduleId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "GetScheduleStatusResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _scheduleEndpoint, message: soapMessage)

    }

    func RemoveSchedule(scheduleId: Int) {

        //copy related soap request structure here

        let sendingElementName = "RemoveSchedule"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><scheduleId>\(scheduleId)</scheduleId></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "RemoveScheduleResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _scheduleEndpoint, message: soapMessage)

    }

    func RemoveScheduleList(scheduleIdList: [Int]) {

        let listAsStringArray = scheduleIdList.map { String($0) }

        

        let intSplitter = "</int><int>"

        let _list = "<int>" + listAsStringArray.joined(separator: intSplitter) + "</int>"

        //copy related soap request structure here

        let sendingElementName = "RemoveScheduleList"

        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(sendingElementName) xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><scheduleIdList>\(_list)</scheduleIdList></\(sendingElementName)></soap:Body></soap:Envelope>"

        expectedElementName = "RemoveScheduleListResponse"

        //use related webservice url here

        initAndSendRequest(endpoint: _scheduleEndpoint, message: soapMessage)

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
