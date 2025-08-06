//
//  MapApplicationApp.swift
//  MapApplication
//
//  Created by Sameer  on 02/08/25.
//

import SwiftUI

@main
struct MapApplicationApp: App {
    
    @StateObject private var vm = LocationsViewModel()
    
    var body: some Scene {
        WindowGroup {
            LocationsView()
                .environmentObject(vm)
        }
    }
}
