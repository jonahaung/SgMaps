//
//  SwiftUIView.swift
//
//
//  Created by Aung Ko Min on 1/8/24.
//

import SwiftUI
import MapKit

public struct SgMrtMapView: View {
    
    private let onSelect: (MRT) -> Void
    private let lines = MRTLine.allCases
    @State var selectedLine: MRTLine?
    @State var selection: MRT?
    @State private var animation: SgAreaAnimation
    @State private var touchedPoint = CLLocationCoordinate2D.singapore
    
    public init(_ onSelect: @escaping (MRT) -> Void) {
        self.onSelect = onSelect
        self.animation = .init()
    }
    
    public var body: some View {
        MapReader { proxy in
            Map(selection: $selection) {
                ForEach(lines) { line in
                    MapPolyline(coordinates: line.coordinates, contourStyle: .geodesic)
                        .stroke(line.color.gradient, style: StrokeStyle(lineWidth: selectedLine == line ? 5 : 3, lineCap: .round, lineJoin: .round))
                    if line == selectedLine {
                        ForEach(line.mrts) { mrt in
                            if let mainSymbol = mrt.mainSymbol(for: line) {
                                Marker(mrt.name, monogram: Text("\(mainSymbol.code)"), coordinate: mrt.coordinate)
                                    .tint(mainSymbol.swiftColor.gradient)
                                    .tag(mrt)
                                
                                ForEach(mrt.symbol) { symbol in
                                    if symbol.code != mainSymbol.code {
                                        Annotation.init(symbol.code, coordinate: mrt.coordinate) {
                                            Circle()
                                                .frame(width: 20, height: 20)
                                                .foregroundStyle(symbol.swiftColor.gradient)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .onTapGesture { position in
                if let coordinate = proxy.convert(position, from: .local) {
                    self.touchedPoint = coordinate
                    if let nearest = self.closestMRT(from: .init(latitude: coordinate.latitude, longitude: coordinate.longitude), mrts: selectedLine?.mrts ?? MRT.allValues) {
                        if nearest.1 <= 10 {
                            if selectedLine == nil {
                                let service = lines.first(where: { $0.mrts.contains { element in
                                    element.name == nearest.0.name
                                } })
                                selectedLine = service
                            }
                        } else {
                            selection = nil
                            selectedLine = nil
                        }
                    }
                }
            }
            .onChange(of: selectedLine) { _, newValue in
                if newValue != nil {
                    animation = .init(touchedPoint, distance: 80000, pitch: 0.25)
                } else {
                    animation = .init(touchedPoint, distance: 120000, pitch: 0.25)
                }
            }
            .onChange(of: selection) { oldValue, newValue in
                if let newValue {
                    animation = .init(distance: 3000, pitch: 0.25)
                } else {
                    animation.pitch = 0.75
                    selectedLine = nil
                }
            }
        }
        .mapStyle(.standard(elevation: .realistic, emphasis: .muted, pointsOfInterest: .excludingAll, showsTraffic: false))
        .mapCameraKeyframeAnimator(trigger: animation) { camera in
            KeyframeTrack(\MapCamera.centerCoordinate) {
                LinearKeyframe(selection?.coordinate ?? touchedPoint, duration: 1)
            }
            KeyframeTrack(\MapCamera.distance) {
                LinearKeyframe(animation.distance, duration: 1)
            }
        }
        
    }
    
    private func closestMRT(from location: CLLocation, mrts: [MRT]) -> (MRT, Int)? {
        var closestMRT: MRT?
        var smallestDistance: CLLocationDistance?
        for mrt in mrts {
            let mrtLocation = CLLocation.init(latitude: mrt.latitude, longitude: mrt.longitude)
            let distance = location.distance(from: mrtLocation)
            
            if smallestDistance == nil || distance < smallestDistance ?? .init() {
                closestMRT = mrt
                smallestDistance = distance
            }
        }
        if let closestMRT, let smallestDistance {
            return (closestMRT, smallestDistance.exponent)
        }
        return nil
    }
}
