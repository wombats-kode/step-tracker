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
    
    var stepData: [HealthMetric] = []
    var weightData: [HealthMetric] = []
    
    func fetchStepCounts() async {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let endDate = calendar.date(byAdding: .day, value: 1, to: today)!
        let startDate = calendar.date(byAdding: .day, value: -28, to: endDate)
        
        let queryPredicate =  HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let samplePredicate = HKSamplePredicate.quantitySample(type: HKQuantityType(.stepCount), predicate: queryPredicate)
        let stepsQuery = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate,
                                                               options: .cumulativeSum,
                                                               anchorDate: endDate,
                                                               intervalComponents: .init(day: 1))
        
        do {
            let stepCounts = try await stepsQuery.result(for: store)
            stepData = stepCounts.statistics().map {
                .init(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .count()) ?? 0)
            }
        } catch {
            
        }
    }
    
    func fetchWeights() async {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let endDate = calendar.date(byAdding: .day, value: 1, to: today)!
        let startDate = calendar.date(byAdding: .day, value: -28, to: endDate)
        
        let queryPredicate =  HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let samplePredicate = HKSamplePredicate.quantitySample(type: HKQuantityType(.bodyMass), predicate: queryPredicate)
        let weightQuery = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate,
                                                                options: .mostRecent,
                                                                anchorDate: endDate,
                                                                intervalComponents: .init(day: 1))
        
        do {
            let weights = try await weightQuery.result(for: store)
            weightData = weights.statistics().map {
                .init(date: $0.startDate, value: $0.mostRecentQuantity()?.doubleValue(for: .pound()) ?? 0)
            }
        } catch {
            
        }
    }
    
    //    func addSimulatorData() async {
    //        var mockSamples: [HKQuantitySample] = []
    //
    //        for i in 0..<28 {
    //            let stepQuantity = HKQuantity(unit: .count(), doubleValue: .random(in: 4_000...20_000))
    //            let weightQuantity = HKQuantity(unit: .pound(), doubleValue: .random(in: (160 + Double(i/3)...165 + Double(i/3))))
    //
    //            let startDate = Calendar.current.date(byAdding: .day, value: -i, to: .now)!
    //            let endDate = Calendar.current.date(byAdding: .second, value: i, to: startDate)!
    //
    //            let stepSample = HKQuantitySample(type: HKQuantityType(.stepCount), quantity: stepQuantity, start: startDate, end: endDate)
    //            let weightSample = HKQuantitySample(type: HKQuantityType(.bodyMass), quantity: weightQuantity, start: startDate, end: endDate)
    //
    //            mockSamples.append(stepSample)
    //            mockSamples.append(weightSample)
    //        }
    //
    //        try! await store.save(mockSamples)
    //        print("✅ Dummy data sent up")
    //    }
    
}
