//
//  LogWithUDP.swift
//  LoggingBase
//
//  Created by Nguyễn Đức Thọ on 07/11/2021.
//

import Foundation
import SwiftSocket
class DebugNetworkManager {
    static let shared = DebugNetworkManager()
    private let consolePipe = ConsolePipe.share
    var host = "127.0.0.1"
    let port = 12345
    lazy var client = UDPClient(address: host, port: Int32(port))
    
    func start() {
        setvbuf(stdout, nil, _IOLBF, 0)
        consolePipe.openConsolePipe()
        consolePipe.output = {[weak self] logString in
            _ = self?.client.send(string: logString)
        }
    }
}
