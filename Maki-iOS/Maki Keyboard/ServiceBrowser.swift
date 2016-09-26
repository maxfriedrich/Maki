//
//  ServiceBrowser.swift
//  Maki-iOS
//

import Foundation

class ServiceBrowser: NSObject, NetServiceBrowserDelegate {

    let serviceBrowser = NetServiceBrowser()
    var services = [NetService]()
    var browsedBlock: (([NetService]) -> Void)?
    
    override init() {
        super.init()
        serviceBrowser.delegate = self
    }
    
    func browse(handler: (([NetService]) -> Void)?) {
        services = []
        serviceBrowser.searchForServices(ofType: "_maki._tcp.", inDomain: "")
        browsedBlock = handler
    }
    
    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        print("will search")
    }
    
    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        print("did stop search")
        browsedBlock?([])
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        print("did not search: \(errorDict)")
        browsedBlock?([])
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        print("did find service: \(service), more coming: \(moreComing)")
        services.append(service)
        if !moreComing {
            browsedBlock?(services)
        }
    }
}
