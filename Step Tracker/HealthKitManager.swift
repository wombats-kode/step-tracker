//
//  HealthKitManager.swift
//  Step Tracker
//
//  Created by Richard Harris on 23/05/2024.
//

import HealthKit
import Foundation
import Observation

@Observable class HealthKitManager {
    
    let store = HKHealthStore()
    let types: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]
    
}
