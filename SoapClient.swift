import UIKit

//Step 1: Add protocol names that we will be delegating.

class ViewController: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate,NSURLConnectionDataDelegate,  XMLParserDelegate {
    
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:String = ""

    @IBOutlet var txtCelsius : UITextField!
    @IBOutlet var txtFahrenheit : UITextField!
    
    @IBAction func actionConvert(_ sender: Any) {
//        let celcius = txtCelsius.text
        
        let username : String = "9122088891"
        let password : String = "1234"
        let to : String = "09103155711"
        let from : String = "500010604095"
        let msg : String = "SOAP Test for iOS"
        let isFlash: Bool = false
        // \(celcius!)
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><SendSimpleSMS2 xmlns='http://tempuri.org/'><username>\(username)</username><password>\(password)</password><to>\(to)</to><from>\(from)</from><text>\(msg)</text><isflash>\(isFlash)</isflash></SendSimpleSMS2></soap:Body></soap:Envelope>"
        
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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if currentElementName == "SendSimpleSMS2Result" {
            txtFahrenheit.text = string
        }
    }
    
    
    
   
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        
        let xmlParser = XMLParser(data: mutableData as Data)
        xmlParser.delegate = self
        xmlParser.parse()
        xmlParser.shouldResolveExternalEntities = true
    }

}

