//
//  ViewController.swift
//  Maki-macOS
//

import Cocoa

class ViewController: NSViewController {
    
    var service: Service?
    var socket: SocketServer?
    
    @IBOutlet weak var textField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service = Service(didPublishBlock: { [unowned self] (service) in
            print("Published Service \(service) on port \(service.port)")
            self.socket = SocketServer(port: service.port)
            }, didNotPublishBlock: { (service, dict) in
                print("did not publish: \(dict)")
        })
    }
    
    @IBAction func sendButtonPushed(_ sender: AnyObject) {
        print(socket)
        socket?.send(textField.stringValue as AnyObject)
        textField.stringValue = ""
    }
    
}

