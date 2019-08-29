//
//  Provider+WhiteList.swift
//  PacketTunnel
//
//  Created by 哔哩哔哩 on 2019/8/27.
//  Copyright © 2019 朱熙. All rights reserved.
//

import NetworkExtension

extension PacketTunnelProvider {
    
    func whiteList() -> [NEIPv4Route] {
        return defaultWhiteList() + customWhiteList()
    }
    
    func defaultWhiteList() -> [NEIPv4Route] {
        return [
            NEIPv4Route.init(destinationAddress: "10.0.0.0", subnetMask: "255.0.0.0"),
            NEIPv4Route.init(destinationAddress: "172.16.0.0", subnetMask: "255.240.0.0"),
            NEIPv4Route.init(destinationAddress: "192.168.0.0", subnetMask: "255.255.0.0"),
        ]
    }
    
    func customWhiteList() -> [NEIPv4Route] {
        
        guard
            let whiteString = UserDefaults.standard.value(forKey: "WhiteList") as? String
        else { return [] }
        
        var whiteNames: [NEIPv4Route] = []
        for hostName in whiteString.split(separator: ",") {
            
            let unsolve = hostName.split(separator: "/")
            guard unsolve.count < 3 && unsolve.count > 0 else { continue }
            
            var ns = unsolve[0].split(separator: ".").map({ UInt8($0) })
            if ns.count < 1 { continue }
            if ns.filter({ $0 == nil }).count > 0 { continue }
            
            ns.append(contentsOf: [0,0,0].map({ Optional(UInt8($0)) }))
            
            let add = String.init(format: "%d.%d.%d.%d", ns[0]!,ns[1]!,ns[2]!,ns[3]!)
            var netmask = "255.255.255.255"
            var mask = ~UInt32(0)
            if ns.count > 1, let sub = Int(unsolve[1]) {
                mask = mask << (32 - sub)
                netmask = mask.ipv4()
            }
            whiteNames.append(NEIPv4Route.init(destinationAddress: add, subnetMask: netmask))
        }
        return whiteNames
    }
}
