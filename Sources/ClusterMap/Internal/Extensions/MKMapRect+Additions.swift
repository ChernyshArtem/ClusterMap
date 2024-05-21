//
//  MKMapRect+Additions.swift
//
//
//  Created by Mikhail Vospennikov on 06.02.2023.
//

import Foundation
import MapKit

extension MKMapRect {
    init(minX: Double, minY: Double, maxX: Double, maxY: Double) {
        self.init(x: minX, y: minY, width: abs(maxX - minX), height: abs(maxY - minY))
    }

    init(x: Double, y: Double, width: Double, height: Double) {
        self.init(origin: MKMapPoint(x: x, y: y), size: MKMapSize(width: width, height: height))
    }

    func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
        contains(MKMapPoint(coordinate))
    }

    init(region: MKCoordinateRegion) {
        self.init()
        
        var topLeft = CLLocationCoordinate2D(
            latitude: min(region.center.latitude + (region.span.latitudeDelta / 2), 90),
            longitude: region.center.longitude - (region.span.longitudeDelta / 2)
        )
        var bottomRight = CLLocationCoordinate2D(
            latitude: max(region.center.latitude - (region.span.latitudeDelta / 2), -90),
            longitude: region.center.longitude + (region.span.longitudeDelta / 2)
        )
        
        if topLeft.longitude < -180 {
            topLeft.longitude = safeDoubleLat(topLeft.longitude)
        }
        if bottomRight.longitude > 180 {
            bottomRight.longitude = safeDoubleLat(bottomRight.longitude)
        }
        
        let topLeftPoint = MKMapPoint(topLeft)
        let bottomRightPoint = MKMapPoint(bottomRight)
        
        self.init(
            x: min(topLeftPoint.x, bottomRightPoint.x),
            y: min(topLeftPoint.y, bottomRightPoint.y),
            width: max(topLeftPoint.x, bottomRightPoint.x) - min(topLeftPoint.x, bottomRightPoint.x),
            height: max(topLeftPoint.y, bottomRightPoint.y) - min(topLeftPoint.y, bottomRightPoint.y)
        )
    }
    
    private func safeDoubleLat(_ n:Double) -> Double {
        (n+180).remainder(dividingBy: 360) - 180
    }
        
}
