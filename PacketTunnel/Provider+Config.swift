//
//  Provider+Config.swift
//  PacketTunnel
//
//  Created by 朱熙 on 2019/8/17.
//  Copyright © 2019 朱熙. All rights reserved.
//

import Foundation

enum ConfigType: UInt32 {
    case IP = 0x00010000
}

extension PacketTunnelProvider {
    
    func getConfig(options: [String : NSObject]?) -> (server: String, port: String) {
        if let s = options?["ServerAddress"] as? String,
            let p = options?["Port"] as? String {
            return (s, p)
        }
        
        if let server = DataCenter.shared.value(forKey: "ServerAddress") as? String,
            let port = DataCenter.shared.value(forKey: "Port") as? String {
            return (server, port)
        }
        return ("", "")
    }
    
    func configIP(callBack: @escaping (String, String) -> Void) {
        self.tcpConn?.readLength(4, completionHandler: { (headerData, headerErr) in
            guard let count = headerData?.uint32, headerErr == nil else {
                return
            }
            guard count & ConfigType.IP.rawValue == ConfigType.IP.rawValue else {
                return
            }
            
            self.tcpConn?.readLength(8, completionHandler: { (pdata: Data?, error: Error?) in
                guard let pdata = pdata else { return }
                NSLog("ips -- \(pdata as NSData)")
                let hostData = pdata[0...3]
                let clientData = pdata[4...7]
                
                let hostIP = hostData.uint32.ipv4()
                let clientIP = clientData.uint32.ipv4()
                NSLog("host IP:\(hostIP), client IP:\(clientIP)")
                
                callBack(hostIP, clientIP)
            })
        })
    }
}
