//
//  SelectedLocationToolbox.swift
//  Uplift
//
//  Created by George Mitrev on 11/11/23.
//

import Foundation
import MapKit

class SelectedLocationToolbox: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
    }
    
    var subtitle: String? {
        return locationName
    }
    
    
}
