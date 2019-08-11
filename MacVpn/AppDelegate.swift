//
//  AppDelegate.swift
//  MacVpn
//
//  Created by 朱熙 on 2019/8/10.
//  Copyright © 2019 朱熙. All rights reserved.
//

import Cocoa
import NetworkExtension

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
        var statusBarItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    @IBOutlet weak var menu: NSMenu!
    
    lazy var vpnManager: NETunnelProviderManager = {
        let manager = NETunnelProviderManager()
        let providerProtocol = NETunnelProviderProtocol()
        providerProtocol.providerBundleIdentifier = self.tunnelBundleId
        providerProtocol.serverAddress = "35.236.153.210"
        
        manager.protocolConfiguration = providerProtocol
        manager.localizedDescription = "VPN_New"
        return manager
    }()
    
    let tunnelBundleId = "com.xizi.macvpn.PacketTunnel"
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        guard let statusButton = statusBarItem.button else { return }
        statusBarItem.button?.title = "Tool"
        statusBarItem.menu = menu
        initVPNTunnelProviderManager()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func startVpn(_ sender: Any) {
        NSLog("==============start vpn")
        self.vpnManager.loadFromPreferences { (error:Error?) in
            if let error = error {
                print(error)
            }
            do {
                try self.vpnManager.connection.startVPNTunnel()
            } catch let err {
                print(err)
            }
            
        }
    }
    
    @IBAction func stopVpn(_ sender: Any) {
        self.vpnManager.connection.stopVPNTunnel()
    }
}

extension AppDelegate {
    private func initVPNTunnelProviderManager() {
        NETunnelProviderManager.loadAllFromPreferences {
            (savedManagers: [NETunnelProviderManager]?, error: Error?) in
            
            if let error = error {
                print(error)
                return
            }
            
            if let savedManagers = savedManagers {
                if savedManagers.count > 0 {
                    self.vpnManager = savedManagers[0]
                }
                
                self.vpnManager.saveToPreferences(completionHandler: { (er) in
                    
                })
            }
            
            self.vpnManager.loadFromPreferences() { (error:Error?) in
                if let error = error {
                    print(error)
                    return
                }
            }
        }
    }
}
