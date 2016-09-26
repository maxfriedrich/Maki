//
//  Socket.swift
//  Maki-iOS
//

import Starscream
import Foundation

class Socket: WebSocketDelegate {
    
    let socket: WebSocket
    let name: String
    let didConnectBlock: ((Socket) -> Void)?
    let didDisconnectBlock: ((Socket, String?) -> Void)?
    let didReceiveMessageBlock: ((Socket, String) -> Void)?
    
    init(host: String, port: UInt, name: String, didConnectBlock: ((Socket) -> Void)?, didDisconnectBlock: ((Socket, String?) -> Void)?, didReceiveMessageBlock: ((Socket, String) -> Void)?) {
        self.name = name
        self.didConnectBlock = didConnectBlock
        self.didDisconnectBlock = didDisconnectBlock
        self.didReceiveMessageBlock = didReceiveMessageBlock
        
        socket = WebSocket(url: webSocketURL(host: host, port: port))
        socket.delegate = self
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }

    func websocketDidConnect(socket: WebSocket) {
        print("Socket connected")
        didConnectBlock?(self)
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("Socket disconnected: \(error)")
        didDisconnectBlock?(self, error?.localizedDescription)
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("Socket did receive message: \(text)")
        didReceiveMessageBlock?(self, text)

    }
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        print("Socket did receive data: \(data)")
    }
}

func webSocketURL(host: String, port: UInt) -> URL {
    let components = NSURLComponents()
    components.scheme = "ws"
    components.host = host
    components.port = NSNumber(value: port)
    components.path = "/"
    
    print("made url: \(components.string!)")
    return URL(string: components.string!)!
}
