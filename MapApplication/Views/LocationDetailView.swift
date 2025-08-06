//
//  LocationDetailView.swift
//  MapApplication
//
//  Created by Sameer  on 05/08/25.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    
    @EnvironmentObject private var vm: LocationsViewModel
    let location: Location
    
    var body: some View {
        ScrollView {
            VStack {
                ImageViewSection
                    .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                titleSection
                Divider()
                descriptionSection
                Divider()
                locationMap
            }
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea()
        .background(Material.ultraThin)
        .overlay(alignment: .topLeading) {
            backButton
        }
    }
}

extension LocationDetailView {
    
    private var ImageViewSection: some View {
        TabView {
            ForEach(location.imageNames, id: \.self) { imageName in
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? nil : UIScreen.main.bounds.width)
                    .clipped()
            }
        }
        .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 1000 : 500)
        .tabViewStyle(.page)
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading) {
            Text(location.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .fontWeight(.bold)
            Text(location.cityName)
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(location.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            if let url = URL(string: location.link) {
                Link("Read more in Wikipedia", destination: url)
                    .tint(Color.blue)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var locationMap: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(center: location.coordinates, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))),
            annotationItems: [location]) { location in
            MapAnnotation(coordinate: location.coordinates) {
                LocationMapAnnotationView()
            }
        }
            .allowsHitTesting(false)
            .aspectRatio(1, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 30))
    }
    
    private var backButton: some View {
        Button {
            vm.sheetLocation = nil
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
                .tint(.primary)
                .padding()
                .background(Material.thick)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 10)
        }
        .padding()
    }
}

#Preview {
    LocationDetailView(location: LocationsDataService.locations.first!)
        .environmentObject(LocationsViewModel())
}
