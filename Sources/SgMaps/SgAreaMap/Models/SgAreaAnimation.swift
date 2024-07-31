//
//  File.swift
//  
//
//  Created by Aung Ko Min on 31/7/24.
//

import Foundation
import MapKit

public struct SgAreaAnimation {
    
    public var coordinate: CLLocationCoordinate2D?
    public var distance: Double?
    public var pitch: Double?
    
    public init(
        _ coordinate: CLLocationCoordinate2D? = .singapore,
        distance: Double? = 80000,
        pitch: Double? = 0.2
    ) {
        self.coordinate = coordinate
        self.distance = distance
        self.pitch = pitch
    }
}
extension SgAreaAnimation: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(coordinate?.latitude)
        hasher.combine(coordinate?.longitude)
        hasher.combine(distance)
        hasher.combine(pitch)
    }
    public static func == (lhs: SgAreaAnimation, rhs: SgAreaAnimation) -> Bool {
        lhs.coordinate == rhs.coordinate &&
        lhs.distance == rhs.distance &&
        lhs.pitch == rhs.pitch
    }
}
public extension CLLocationCoordinate2D {
    static let singapore: CLLocationCoordinate2D = .init(latitude: 1.3521, longitude: 103.8198)
}
