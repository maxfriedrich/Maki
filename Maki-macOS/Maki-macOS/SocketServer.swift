//
//  SocketServer.swift
//  Maki-macOS
//

import Foundation

class SocketServer: NSObject, MBWebSocketServerDelegate {
 
    fileprivate var socket: MBWebSocketServer!
    
    init(port: UInt) {
        super.init()
        socket = MBWebSocketServer(port: port, delegate: self)
    }
    
    func send(_ object: AnyObject) {
        socket.send(object)
        print("did send")
    }
    
    func webSocketServer(_ webSocketServer: MBWebSocketServer!, didAcceptConnection connection: GCDAsyncSocket!) {
    print("server did accept connection")
    }
    
    func webSocketServer(_ webSocket: MBWebSocketServer!, didReceive data: Data!, fromConnection connection: GCDAsyncSocket!) {
        print("server did receive data")
    }
    
    func webSocketServer(_ webSocketServer: MBWebSocketServer!, clientDisconnected connection: GCDAsyncSocket!) {
        print("client disconnected")
    }
    
    func webSocketServer(_ webSocketServer: MBWebSocketServer!, couldNotParseRawData rawData: Data!, fromConnection connection: GCDAsyncSocket!, error: Error!) {
        print("could not parse raw data")
    }
}
