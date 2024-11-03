//
//  subChart.swift
//  autocommentIq Watch App
//
//  Created by Gokula Krishnan R on 01/04/24.
//

import SwiftUI
import Charts

struct SubChart: View {
    @ObservedObject var analysisYT = AnalysisYTNetwork()
    @State private var isShowingAnalysisYTView = false
    var body: some View {
        VStack{
            if let subscribersGained = analysisYT.analysisY?.values.subscribersGained {
                // Header with title and "See More" button
                HStack {
                    Text("Subscribers Gained")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        
                    
                    Spacer()
                    
                    Button(action: {
                        // Action to navigate to the full page
                        isShowingAnalysisYTView = true
                    }) {
                        Text("See More")
                            .font(.system(size: 10))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8) // Apply rounded corners
                                    .stroke(Color.gray, lineWidth: 1) // Add border
                            )
                    }
                    .buttonStyle(.plain) // Apply plain button style
                    .sheet(isPresented: $isShowingAnalysisYTView) {
                        AnalysisYTView()
                    }
                }
                if let analysisData = analysisYT.analysisY?.values {
                    ChartView(analysisData: analysisData , count: "estimatedMinutesWatched")
                                  .padding(.vertical, 12)
                          } else {
                              ProgressView()
                          }
//                ??Chart
//                Chart(subscribersGained) {
//                    LineMark(
//                        x: .value("Month", $0.date),
//                        y: .value("Subscribers Gained", $0.subscribersGained)
//                    )
//                    .interpolationMethod(.catmullRom)
//                    
//                    AreaMark(
//                        x: .value("Month", $0.date),
//                        y: .value("Subscribers Gained", $0.subscribersGained)
//                    )
//                    .interpolationMethod(.catmullRom)
//                    .foregroundStyle(Color("Blue").opacity(0.1).gradient)
//                }
//                .padding()
//                .chartYAxis() {
//                    AxisMarks(position: .leading)
//                }
//                .frame(height: 100)
//                .chartLegend(position: .overlay, alignment: .top)
//                .padding(.vertical , 12)
            } else {
                ProgressView()
            }
        }
        .padding(.vertical , 8)
        .onAppear{
            self.analysisYT.fetchAnalysis()
            print(self.analysisYT.analysisY , "hi") 
        }
    }
}

struct SubChart_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}






