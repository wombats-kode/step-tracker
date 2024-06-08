//
//  HealthDataListView.swift
//  Step Tracker
//
//  Created by Richard Harris on 20/05/2024.
//

import SwiftUI

struct HealthDataListView: View {
    
    @Environment(HealthKitManager.self) private var hkManager
    @State private var isShowingAddData = false
    @State private var addDataData: Date = .now
    @State private var valueToAdd: String = ""
        
    var metric: HealthMetricContext
    
    var listData: [HealthMetric] {
        metric == .steps ? hkManager.stepData : hkManager.weightData
    }
    
    var body: some View {
        List(listData.reversed()) { data in
            HStack {
                Text(data.date, format: .dateTime.month().day().year())
                Spacer()
                Text(data.value, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
            }
        }
        .navigationTitle(metric.title)
        .sheet(isPresented: $isShowingAddData) {
            addDataView
        }
        .toolbar {
            Button("Add Data", systemImage: "plus") {
                isShowingAddData = true
            }
        }
    }
    
    var addDataView: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $addDataData, displayedComponents: .date)
                HStack {
                    Text(metric.title)
                    Spacer()
                    TextField("value", text: $valueToAdd)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 140)
                        .keyboardType(metric == .steps ? .numberPad : .decimalPad)
                }
            }
            .navigationTitle((metric.title))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Data") {
                        Task {
                            if metric == .steps {
                                do {
                                    try await hkManager.addStepData(for: addDataData, value: Double(valueToAdd)!)
                                    try await hkManager.fetchStepCounts()
                                    isShowingAddData = false
                                } catch STError.sharingDenied(let quantityType) {
                                    print("❌ sharing denied for \(quantityType)")
                                } catch {
                                    print("❌ Data List View unable to complete request")
                                }
                            } else {
                                do {
                                    try await hkManager.addWeightData(for: addDataData, value: Double(valueToAdd)!)
                                    try await hkManager.fetchWeights()
                                    try await hkManager.fetchWeightsForDifferentials()
                                    isShowingAddData = false
                                } catch STError.sharingDenied(let quantityType) {
                                    print("❌ sharing denied for \(quantityType)")
                                } catch {
                                    print("❌ Data List View unable to complete request")
                                }
                            }
                                
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss") {
                        isShowingAddData = false
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack{
        HealthDataListView(metric: .steps)
            .environment(HealthKitManager())
    }
}
