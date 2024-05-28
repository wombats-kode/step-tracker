//
//  ChartMath.swift
//  Step Tracker
//
//  Created by Richard Harris on 26/05/2024.
//

import Algorithms
import Foundation

struct ChartMath {
    
    static func averageWeekdayCount( for metric: [HealthMetric]) -> [WeekdayChartData] {
        let sortedByWeekday = metric.sorted { $0.date.weekdayInt < $1.date.weekdayInt }
        let weekdayArray = sortedByWeekday.chunked { $0.date.weekdayInt == $1.date.weekdayInt }
        
        var weekdayChartData: [WeekdayChartData] = []
        
        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) {$0 + $1.value }
            let avgSteps = total/Double(array.count)
            
            weekdayChartData.append(.init(date: firstValue.date, value: avgSteps))
        }
        
        return weekdayChartData
    }
    
    static func averageDailyWeightDiffs(for weights: [HealthMetric]) -> [WeekdayChartData] {
        var diffvalues: [(date: Date, value: Double)] = []
        
        for i in 1..<weights.count {  // Start at 2nd element to account for dif calculation [i - 1]
                let date = weights[i].date
                let diff = weights[i].value - weights[i - 1].value
                diffvalues.append((date: date, value: diff))
        }
        
        let sortedByWeekday = diffvalues.sorted { $0.date.weekdayInt < $1.date.weekdayInt }
        let weekdayArray = sortedByWeekday.chunked { $0.date.weekdayInt == $1.date.weekdayInt }
        
        var weekdayChartData: [WeekdayChartData] = []
        
        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) {$0 + $1.value }
            let avgWeightDiff = total/Double(array.count)
            
            weekdayChartData.append(.init(date: firstValue.date, value: avgWeightDiff))
        }

        return weekdayChartData
    }
}
