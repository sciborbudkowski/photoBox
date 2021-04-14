//
//  DeviceOrientation.swift
//  photoBox
//
//  Created by Ścibor Budkowski on 14/04/2021.
//

import UIKit

class DeviceOrientation {
    
    public static func isPortrait() -> Bool {
        if UIDevice.current.orientation.isPortrait {
            return true
        }
        
        return false
    }
}
