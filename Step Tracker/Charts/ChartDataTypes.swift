//
//  ChartDataTypes.swift
//  Step Tracker
//
//  Created by Richard Harris on 26/05/2024.
//

import Foundation

struct WeekdayChartData: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
