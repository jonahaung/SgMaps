//
//  File.swift
//  
//
//  Created by Aung Ko Min on 4/8/24.
//

import Foundation
public struct MRTService: Hashable, Identifiable {
    
    public var id: String { line.code + mrts.count.description }
    public let line: MRTLine
    public let mrts: [MRT]
    public let polygonRegion: PolygonRegion
    
    public init(_ line: MRTLine) {
        self.line = line
        self.mrts = line.mrts
        self.polygonRegion = .init(verticies: line.mrts.map{ $0.coordinate })
    }
    public var coordinates: [CLLocationCoordinate2D] { polygonRegion.verticies }
}
