//
//  CoordinateIdentifiable.swift
//
//
//  Created by Mikhail Vospennikov on 28.08.2023.
//

import CoreLocation
import Foundation

/// A protocol that defines the requirements for an object to be identifiable by its geographical coordinate.
///
/// - Note: By default, `shouldCluster` is set to `true`. Override this property if you want to control its value.
///
/// Example:
///
/// ```swift
/// struct MyAnnotation: CoordinateIdentifiable {
///     var coordinate: CLLocationCoordinate2D
///     var shouldCluster: Bool = false  // This annotation won't be clustered
/// }
/// ```
public protocol CoordinateIdentifiable {
    /// The geographical coordinate of the object.
    let coordinate: CLLocationCoordinate2D

    /// A Boolean value that determines whether the object should be included in clustering operations.
    ///
    /// The default value is `true`.
    let shouldCluster: Bool = true
}
