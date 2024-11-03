//
//  AnalysisYT.swift
//  autocommentIq Watch App
//
//  Created by Gokula Krishnan R on 01/04/24.
//

import Foundation


class AnalysisYTNetwork: ObservableObject {
        @Published var analysisY: AnalysisT?
   
            func fetchAnalysis() {
                guard let url = URL(string: "http://localhost:3000/v1/youtube-analytics?startDate=2024-01-01&endDate=2024-04-01&hero=subscribersGained,views,likes,comments,estimatedMinutesWatched,averageViewDuration,shares,dislikes,annotationImpressions,annotationClickThroughRate,annotationCloseRate,viewsPerPlaylistStart,averageTimeInPlaylist") else { return }
        
                var request = URLRequest(url: url)
        
                // Replace "YOUR_BEARER_TOKEN" with your actual bearer token
                let bearerToken = "ya29.a0Ad52N3_GXnQ6RSQmzbIA9h88DEj8HKLJtEwwCriwlZ7tE64ECA7zeVsEmUM1IOY6mOtcAUyeLUJBUZEqrJg8p1RTpuI2lv5PjlCihTrZuy3AvBVqTk344ZyaUECsF5Z5TYNZbQ0bNge9fmFWf29NTCtYRPaT2isW85YaCgYKAbcSARASFQHGX2MizgdBRcdlZsDGK5OBde83tw0170"
        
                // Add authorization header
                request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
                URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data else { return }
                    do {
                        let analysisYT = try JSONDecoder().decode(AnalysisT.self, from: data)
                        DispatchQueue.main.async {
                            self.analysisY = analysisYT
//                            print(analysisYT)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }.resume()
            }

}
