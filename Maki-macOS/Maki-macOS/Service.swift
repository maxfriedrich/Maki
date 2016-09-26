//
//  Service.swift
//  Maki-macOS
//

import Foundation

class Service: NSObject, NetServiceDelegate {
    
    let netService = NetService(domain: "", type: "_maki._tcp.", name: "", port: 0)
    
    var didPublishBlock: ((Service) -> Void)?
    var didNotPublishBlock: ((Service, [String : NSNumber]) -> Void)?
    
    var port: UInt {
        return UInt(netService.port)
    }
    
    override var description: String {
        return netService.description
    }
    
    init(didPublishBlock: ((Service) -> Void)?, didNotPublishBlock: ((Service, [String : NSNumber]) -> Void)?) {
        self.didPublishBlock = didPublishBlock
        self.didNotPublishBlock = didNotPublishBlock
        super.init()
        netService.delegate = self

        // Workaround: publish and stop the service to get a free port number from the system.
        netService.publish(options: .listenForConnections)
        netService.stop()
        
        netService.publish()
    }
    
    func netServiceDidPublish(_ sender: NetService) {
        didPublishBlock?(self)
    }
    
    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        didNotPublishBlock?(self, errorDict)
    }
    

    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        print("did not resolve: \(errorDict)")
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        print("did resolve address: \(sender.hostName)")
    }
}
