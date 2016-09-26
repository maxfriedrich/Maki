//
//  KeyboardViewController.swift
//  Maki Keyboard
//

import UIKit

class KeyboardViewController: UIInputViewController, UIPopoverPresentationControllerDelegate {
    
    var socket: Socket?
    
    @IBOutlet weak var connectBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    var keyboard: UIView!
    
    override func viewDidLoad() {
        let nib = UINib(nibName: "Keyboard", bundle: nil)
        let objects = nib.instantiate(withOwner: self, options: nil)
        keyboard = objects[0] as! UIView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        keyboard.frame = (inputView?.frame)!
        inputView?.addSubview(keyboard)
        updateEnabled()
    }
    
    func updateEnabled() {
        if isOpenAccessEnabled() { // FIXME always returns true
            connectBarButtonItem.isEnabled = true
        } else {
            connectBarButtonItem.isEnabled = false
            statusLabel.text = "Enable Full Access in Settings"
        }
    }
    
    @IBAction func connectButtonPushed(_ sender: AnyObject) {
        let browseServices = BrowseServicesViewController()
        browseServices.didSelectService = {[unowned self] host, port, name in
            self.socket?.disconnect()
            self.socket = Socket(host: host, port: port, name: name, didConnectBlock: {[unowned self] socket in
                // set image
                self.statusLabel.text = "Connected to \(socket.name)"
                }, didDisconnectBlock: { [unowned self] socket, error in
                    // set image
                    self.statusLabel.text = "Disconnected: \(error)"
                    print(error)
                }, didReceiveMessageBlock: { [unowned self] socket, text in
                    // enter text
                    self.textDocumentProxy.insertText(text)
                })
        }
        showPopover(viewController: browseServices, fromBarButtonItem: connectBarButtonItem)
    }
    
    func showPopover(viewController: UIViewController, fromBarButtonItem barButtonItem: UIBarButtonItem) {
        let nav = UINavigationController(rootViewController: viewController)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController!
        viewController.preferredContentSize = CGSize(width: 200, height: 150)
        popover.delegate = self
        popover.barButtonItem = barButtonItem
        
        self.present(nav, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    @IBAction func nextButtonPushed(_ sender: AnyObject) {
        socket?.disconnect()
        advanceToNextInputMode()
    }
}
