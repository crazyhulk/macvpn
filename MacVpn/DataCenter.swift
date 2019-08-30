//
//  DataCenter.swift
//  MacVpn
//
//  Created by 哔哩哔哩 on 2019/8/30.
//  Copyright © 2019 朱熙. All rights reserved.
//

import Foundation

public class DataCenter {
    public static let shared = DataCenter()
    let groupIdentifier = "95923X8WXP.macvpn"
    lazy var manager = UserDefaults.init(suiteName: self.groupIdentifier)
    
    func set(_ value: Any, forKey: String) {
        manager?.setValue(value, forKey: forKey)
    }
    
    func value(forKey: String) -> Any? {
        return manager?.value(forKey: forKey)
    }
}
