//
//  LocationsView.swift
//  MapApplication
//
//  Created by Sameer  on 02/08/25.
//

import SwiftUI
import MapKit

struct LocationsView: View {
    
    @EnvironmentObject private var vm: LocationsViewModel
    private let maxWidth: CGFloat = 700
    
    var body: some View {
        ZStack {
            locationMap
                .ignoresSafeArea()
            
            VStack {
                header
                    .padding()
                    .frame(maxWidth: maxWidth)
                Spacer()
                locationPreviewStack
            }
        }
        .fullScreenCover(item: $vm.sheetLocation, onDismiss: .none) { location in
            LocationDetailView(location: location)
        }
    }
}

extension LocationsView {
    
    private var header: some View {
        VStack {
            Button {
                vm.toggleLocationsList()
            } label: {
                Text(vm.mapLocation.name + ", " + vm.mapLocation.cityName)
                    .font(.title2)
                    .fontWeight(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .animation(.none, value: vm.mapLocation)
                    .overlay(alignment: .leading) {
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundStyle(Color.primary)
                            .padding()
                            .rotationEffect(Angle(degrees: vm.showLocationsList ? 180 : 0))
                    }
            }
            .foregroundStyle(.primary)

            if vm.showLocationsList {
                LocationListView()
            }
        }
        .background(Material.ultraThick)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 15)
    }
    
    private var locationMap: some View {
        Map(coordinateRegion: $vm.mapRegion,
            annotationItems: vm.locations) { location in
            MapAnnotation(coordinate: location.coordinates) {
                LocationMapAnnotationView()
                    .scaleEffect(vm.mapLocation == location ? 1 : 0.7)
                    .shadow(radius: 10)
                    .onTapGesture {
                        vm.showNextLocation(location: location)
                    }
            }
        }
    }
    
    private var locationPreviewStack: some View {
        ZStack {
            ForEach(vm.locations) { location in
                if vm.mapLocation == location {
                    LocationPreviewView(location: location)
                        .shadow(color: Color.black.opacity(0.3),
                                radius: 20)
                        .padding()
                        .frame(maxWidth: maxWidth)
                        .frame(maxWidth: .infinity)
                        .transition(AnyTransition.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)))
                }
            }
        }
    }
}

#Preview {
    LocationsView()
        .environmentObject(LocationsViewModel())
}
