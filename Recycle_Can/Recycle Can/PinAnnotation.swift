//
//  PinAnnotation.swift
//  Recycle Can
//
//  Created by - on 2017/06/03.
//  Copyright © 2017 Recycle Canada. All rights reserved.
//

import MapKit

class PinAnnotation: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    
    
}
