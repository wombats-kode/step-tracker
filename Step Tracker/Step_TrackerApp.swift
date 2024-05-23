//
//  Step_TrackerApp.swift
//  Step Tracker
//
//  Created by Richard Harris on 20/05/2024.
//

import SwiftUI

@main
struct Step_TrackerApp: App {
    
    let hkManager = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(hkManager)
        }
    }
}
