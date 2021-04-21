//
//  LocalData.swift
//  photoBox
//
//  Created by Ścibor Budkowski on 13/04/2021.
//

import Foundation

struct LocalDataKeys {
    
    static let numberOfPicsToDownload = "numberOfPicsToDownload"
    static let photoViewMode = "photoViewMode"
    static let photoShowInfo = "photoShowInfo"
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
    
    public var photoViewMode: String {
        get {
            let mode = defaults.string(forKey: LocalDataKeys.photoViewMode)
            if let mode = mode {
                return mode
            }
            else {
                defaults.setValue("scaleAspectFill", forKey: LocalDataKeys.photoViewMode)
                return "scaleAspectFill"
            }
        }
        
        set {
            defaults.setValue(newValue, forKey: LocalDataKeys.photoViewMode)
        }
    }
    
    public var photoShowInfo: Bool {
        get {
            let showInfo = defaults.bool(forKey: LocalDataKeys.photoShowInfo)
            return showInfo
        }
        
        set {
            defaults.setValue(newValue, forKey: LocalDataKeys.photoShowInfo)
        }
    }
}
