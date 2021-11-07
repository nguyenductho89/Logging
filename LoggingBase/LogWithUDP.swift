//
//  LogWithUDP.swift
//  LoggingBase
//
//  Created by Nguyễn Đức Thọ on 07/11/2021.
//

import Foundation
import SwiftSocket

//nc -ul 12345
class DebugNetworkManager {
    static let shared = DebugNetworkManager()
    private let consolePipe = ConsolePipe.share
    private var host = "127.0.0.1"
    private var port = Int32(12345)
    private lazy var client = UDPClient(address: host, port: port)
    
    func setHost(_ host: String, port:Int32) {
        self.host = host
        self.port = port
        client = UDPClient(address: host, port: port)
    }
    
    func start() {
        setvbuf(stdout, nil, _IOLBF, 0)
        consolePipe.openConsolePipe()
        consolePipe.output = {[weak self] logString in
            _ = self?.client.send(string: logString)
        }
    }
}
