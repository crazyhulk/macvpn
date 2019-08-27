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
        return defaultWhiteList()
    }
    
    func defaultWhiteList() -> [NEIPv4Route] {
        return [
            NEIPv4Route.init(destinationAddress: "10.0.0.0", subnetMask: "255.0.0.0"),
            NEIPv4Route.init(destinationAddress: "172.16.0.0", subnetMask: "255.240.0.0"),
            NEIPv4Route.init(destinationAddress: "192.168.0.0", subnetMask: "255.255.0.0"),
        ]
    }
}
