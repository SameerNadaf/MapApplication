//
//  LocationsViewModel.swift
//  MapApplication
//
//  Created by Sameer  on 02/08/25.
//

import Foundation
import MapKit
import SwiftUI

class LocationsViewModel: ObservableObject {
    @Published var locations: [Location]
    
    @Published var mapLocation: Location {
        didSet {
            upadteMapRegion(location: mapLocation)
        }
    }
    
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    @Published var showLocationsList: Bool = false
    @Published var sheetLocation: Location? = nil
    
    init() {
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!
        
        self.upadteMapRegion(location: locations.first!)
    }
    
    private func upadteMapRegion(location: Location) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(
                center: location.coordinates,
                span: span)
        }
    }
    
    func toggleLocationsList() {
        withAnimation(.easeInOut) {
            showLocationsList.toggle()
        }
    }
    
    func showNextLocation(location: Location) {
        withAnimation(.easeInOut) {
            mapLocation = location
            showLocationsList = false
        }
    }
    
    func nextButtonPressed() {
        guard let currentIndex = locations.firstIndex(where: {$0 == mapLocation}) else { return }
        
        let nextIndex = currentIndex + 1
        guard locations.indices.contains(nextIndex) else {
            let firstLocation = locations.first!
            showNextLocation(location: firstLocation)
            return
        }
        
        let nextLocation = locations[nextIndex]
        showNextLocation(location: nextLocation)
    }
}
