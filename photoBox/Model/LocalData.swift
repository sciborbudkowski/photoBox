//
//  LocalData.swift
//  photoBox
//
//  Created by Ścibor Budkowski on 13/04/2021.
//

import Foundation

struct LocalDataKeys {
    
    static let numberOfPicsToDownload = "numberOfPicsToDownload"
}

class LocalData {
    
    static let instance = LocalData()
    
    private let defaults = UserDefaults.standard
    
    public var numberOfPicsToDownload: Int {
        get {
            let number = defaults.integer(forKey: LocalDataKeys.numberOfPicsToDownload)
            if number == 0 {
                defaults.setValue(24, forKey: LocalDataKeys.numberOfPicsToDownload)
                return 24
            }
            
            return number
        }
        
        set {
            defaults.setValue(newValue, forKey: LocalDataKeys.numberOfPicsToDownload)
        }
    }
}
