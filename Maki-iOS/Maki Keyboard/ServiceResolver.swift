//
//  ServiceResolver.swift
//  Maki-iOS
//

import Foundation

class ServiceResolver: NSObject, NetServiceDelegate {

    var didResolveBlock: ((String, UInt, String) -> Void)?
    
    func resolve(service: NetService, didResolveBlock: ((String, UInt, String) -> Void)?) {
        service.delegate = self
        service.resolve(withTimeout: 10.0)
        self.didResolveBlock = didResolveBlock
    }
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        print("Net service did not resolve")
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        didResolveBlock?(sender.hostName!, UInt(sender.port), sender.name)
    }
}
