import SwiftUI
import Charts

struct ChartView: View {
    var analysisData: AnalysisTValues // AnalysisTValues containing all the data
    var count: String
    var body: some View {
        VStack{
            Chart(analysisData.estimatedMinutesWatched) {
                LineMark(
                    x: .value("Month", $0.date),
                    y: .value("Subscribers Gained", $0.estimatedMinutesWatched)
                )
                .interpolationMethod(.catmullRom)
                
                AreaMark(
                    x: .value("Month", $0.date),
                    y: .value("Subscribers Gained", $0.estimatedMinutesWatched)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(Color("Blue").opacity(0.1).gradient)
            }
            .padding()
            .chartYAxis() {
                AxisMarks(position: .leading)
            }
            .frame(height: 100)
            .chartLegend(position: .overlay, alignment: .top)
            .padding(.vertical , 12)
        
        }
    }
}
