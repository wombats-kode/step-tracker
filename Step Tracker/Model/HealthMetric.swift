//
//  HealthMetric.swift
//  Step Tracker
//
//  Created by Richard Harris on 24/05/2024.
//

import Foundation

struct HealthMetric: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
