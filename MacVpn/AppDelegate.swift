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
    
    lazy var window: NSWindow = {
        let window = NSWindow.init(contentRect: NSRect.init(x: 500, y: 500, width: 500, height: 500),
                               styleMask: [NSWindow.StyleMask.titled, .closable],
                               backing: NSWindow.BackingStoreType.buffered,
                               defer: true)
        window.contentViewController = ViewController()
        return window
    }()
    
    lazy var vpnManager: NETunnelProviderManager = {
        let manager = NETunnelProviderManager()
        let providerProtocol = NETunnelProviderProtocol()
        providerProtocol.providerBundleIdentifier = self.tunnelBundleId
        providerProtocol.username = "superuser"
        
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
        guard let port = UserDefaults.standard.value(forKey: "Port") as? String else {
            return
        }
        NETunnelProviderManager.loadAllFromPreferences { (managers, error) in
            guard error == nil else { return }
            
            guard let _managers = managers, _managers.count > 0 else {
                return
            }
            
            self.vpnManager = _managers[0]
            
            do {
                try self.vpnManager.connection.startVPNTunnel(options: [
                    "Port": port as NSString
                    ])
            } catch let err {
                print(err)
            }
        }
    }
    
    @IBAction func stopVpn(_ sender: Any) {
        self.vpnManager.connection.stopVPNTunnel()
    }
    
    @IBAction func configVPN(_ sender: Any) {
        guard window.isVisible == false else {
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        window.makeKey()
        window.setIsVisible(true)
    }
    
    
    @IBAction func exitApp(_ sender: Any) {
        self.vpnManager.connection.stopVPNTunnel()
        exit(0)
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
                } else {
                    self.window.makeKey()
                    self.window.setIsVisible(true)
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
