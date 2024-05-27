//
//  ContentView.swift
//  Step Tracker
//
//  Created by Richard Harris on 20/05/2024.
//

import Charts
import SwiftUI

enum HealthMetricContext: CaseIterable, Identifiable {
    case steps, weight

    var id: Self {self} // required to conform to CaseIterable
    
    var title: String {
        switch self {
        case .steps:
            return "Steps"
        case .weight:
            return "Weight"
        }
    }
}

struct DashboardView: View {
    @Environment(HealthKitManager.self) private var hkManager
    @AppStorage("hasSeenPermissionPriming") private var hasSeenPermissionPriming = false
    
    @State private var isShowingPermissionPrimingSheet = false
    @State private var selectedStat: HealthMetricContext = .steps
    var isSteps: Bool { selectedStat == .steps}
    
    var body: some View {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 20) {
                        
                        Picker("Selected Stat", selection: $selectedStat) {
                            ForEach(HealthMetricContext.allCases) {
                                Text($0.title)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        switch selectedStat {
                        case .steps:
                            StepBarChart(selectedStat: selectedStat, chartData: hkManager.stepData)
                            StepPieChart(chartData: ChartMath.averageWeekdayCount(for: hkManager.stepData))
                        case .weight:
                            WeightLineChart(selectedStat: .weight, chartData: hkManager.weightData)
                        }
                    }
                }
                .padding()
                .task {
                    await hkManager.fetchStepCounts()
                    await hkManager.fetchWeights()
                    isShowingPermissionPrimingSheet = !hasSeenPermissionPriming
                }
                .navigationTitle("Dashboard")
                .navigationDestination(for: HealthMetricContext.self) { metric in
                    HealthDataListView(metric: metric)
                }
                .sheet(isPresented: $isShowingPermissionPrimingSheet, onDismiss: {
                    // fetch health data
                }, content: {
                    HealthKitPermissionPrimingView(hasSeen: $hasSeenPermissionPriming)
                })
            }
            .tint(isSteps ? .pink : .indigo)
    }
}

#Preview {
    DashboardView()
        .environment(HealthKitManager())
}
