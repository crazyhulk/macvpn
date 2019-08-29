//
//  ViewController.swift
//  MacVpn
//
//  Created by 朱熙 on 2019/8/18.
//  Copyright © 2019 朱熙. All rights reserved.
//

import Cocoa
import NetworkExtension

class ViewController: NSViewController {
    @IBOutlet weak var serverLabel: NSTextField!
    @IBOutlet weak var portLabel: NSTextField!

    @IBOutlet var whiteListTextView: NSTextView!
    
    let tunnelBundleId = "com.xizi.macvpn.PacketTunnel"
    
    lazy var vpnManager: NETunnelProviderManager = {
        let manager = NETunnelProviderManager()
        let providerProtocol = NETunnelProviderProtocol()
        providerProtocol.providerBundleIdentifier = self.tunnelBundleId
//        providerProtocol.serverAddress = ""
        providerProtocol.username = "superuser"
        
        manager.protocolConfiguration = providerProtocol
        manager.localizedDescription = "VPN_New"
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        if let server = UserDefaults.standard.value(forKey: "Server") as? String {
            serverLabel.stringValue = server
        }
        
        if let port = UserDefaults.standard.value(forKey: "Port") as? String  {
            portLabel.stringValue = port
        }
    }
    
    @IBAction func saveConfigration(_ sender: Any) {
        let server = serverLabel.stringValue
        let port = portLabel.stringValue
        let whiteList = whiteListTextView.string
        
        UserDefaults.standard.set(server, forKey: "Server")
        UserDefaults.standard.set(port, forKey: "Port")
        UserDefaults.standard.set(port, forKey: "WhiteList")
        
        
        
        NETunnelProviderManager.loadAllFromPreferences { (managers, error) in
            guard error == nil else { return }
            
            guard let _managers = managers, _managers.count > 0 else {
                let providerProtocol = NETunnelProviderProtocol()
                providerProtocol.providerBundleIdentifier = self.tunnelBundleId
                providerProtocol.serverAddress = server
                providerProtocol.username = "superuser"
                self.vpnManager.protocolConfiguration = providerProtocol
                self.vpnManager.saveToPreferences(completionHandler: { (err) in
                    
                })
                return
            }
            
            self.vpnManager = _managers[0]
            
            do {
                try self.vpnManager.connection.startVPNTunnel(options: [
                    "Port": port as NSString,
                    "whiteList": whiteList as NSString
                    ])
            } catch let err {
                print(err)
            }
        }
        
//        self.vpnManager.loadFromPreferences { (error:Error?) in
//            if let error = error {
//                print(error)
//            }
//            do {
//                try self.vpnManager.connection.startVPNTunnel(options: [
//                    "Port": port as NSString
//                    ])
//            } catch let err {
//                print(err)
//            }
//            
//        }
    }
}


extension ViewController {
    
    func parseWhiteList() -> String {
        return whiteListTextView
            .string
            .filter({ !" \n\t\r".contains($0) })
    }
}
