//
//  MKMapView.Extension.swift
//  photoBox
//
//  Created by Ścibor Budkowski on 13/04/2021.
//

import Foundation
import MapKit

extension MKMapView {
    
    func centerToLocation(_ location: CLLocationCoordinate2D, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        
        setRegion(coordinateRegion, animated: true)
    }
    
    func centerToCoordinates(_ coordinates: CLLocationCoordinate2D, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: coordinates,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        
        setRegion(coordinateRegion, animated: true)
    }
}
