//
//  DropablePinout.swift
//  photoBox
//
//  Created by Ścibor Budkowski on 13/04/2021.
//

import UIKit
import MapKit

class DropablePinout: NSObject, MKAnnotation {
    
    dynamic var coordinate: CLLocationCoordinate2D
    var identifier: String
    
    init(coordinate: CLLocationCoordinate2D, identifier: String) {
        self.coordinate = coordinate
        self.identifier = identifier
        
        super.init()
    }
}
