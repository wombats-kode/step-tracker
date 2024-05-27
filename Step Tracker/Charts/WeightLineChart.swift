//
//  WeightLineChart.swift
//  Step Tracker
//
//  Created by Richard Harris on 27/05/2024.
//

import Charts
import SwiftUI

struct WeightLineChart: View {
    
    var selectedStat: HealthMetricContext
    var chartData: [HealthMetric]
    
    var minValue: Double {
        chartData.map { $0.value }.min() ?? 0
    }
    
    var body: some View {
        VStack {
            NavigationLink(value: selectedStat) {
                HStack {
                    VStack {
                        Label("Weight", systemImage: "figure")
                            .font(.title3.bold())
                            .foregroundStyle(.indigo)
                        
                        Text("Avg: 180lbs")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                }
            }
            .foregroundStyle(.secondary)
            .padding(.bottom, 12)
            
            Chart {
                RuleMark(y: .value("Goal", 155))
                    .foregroundStyle(.mint)
                    .lineStyle(.init(lineWidth: 1, dash: [5]))
                
                ForEach(chartData) { weight in
                    AreaMark(
                        x: .value("Day", weight.date, unit: .day),
                        yStart: .value("value", weight.value),
                        yEnd: .value("Min Value", minValue)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(Gradient(colors: [.indigo.opacity(0.5), .clear]))
                    
                    LineMark(
                        x: .value("Day", weight.date),
                        y: .value("value", weight.value)
                    )
                    .foregroundStyle(.indigo)
                    .interpolationMethod(.catmullRom)
                    .symbol(.circle)
                }
            }
            .frame(height: 150)
            .chartYScale(domain: .automatic(includesZero: false))
            .chartXAxis {
                AxisMarks{
                    AxisValueLabel(format: .dateTime.month(.defaultDigits).day())
                }
            }
            .chartYAxis {
                AxisMarks {value in
                    AxisGridLine()
                        .foregroundStyle(Color.secondary.opacity(0.3))
                    
                    AxisValueLabel()
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
}

#Preview {
    WeightLineChart(selectedStat: .weight, chartData: MockData.weights)
}
