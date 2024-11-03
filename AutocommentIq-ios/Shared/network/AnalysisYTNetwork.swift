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
                guard let url = URL(string: "http://localhost:3000/v1/youtube-analytics?startDate=2024-01-01&endDate=2024-04-01&hero=subscribersGained") else { return }
        
                var request = URLRequest(url: url)
        
                // Replace "YOUR_BEARER_TOKEN" with your actual bearer token
                let bearerToken = "ya29.a0Ad52N3-Ugid56EJSgU6K-SYRPIp6wCB9bHs2wSrId1dKtZbtERV_hNzQubOikYIhE35QHvdi6Nj_hsztDDJfasPsOpb0Fj0O4s0bg2Lww6-92SOWcJJ-i8E9MRS0LCr_bDCe9qjufwEWj1b7d7yW8HEP1TEANab4OTIaCgYKAbwSARASFQHGX2MiMFF5UTqDThaVF86TFw8FNw0170"
        
                // Add authorization header
                request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error fetching video data:", error.localizedDescription)
                        return
                    }
                    
                    guard let data = data else {
                        print("No data received from the server")
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let analysisYT = try decoder.decode(AnalysisT.self, from: data)
                        DispatchQueue.main.async {
                            self.analysisY = analysisYT
//                            print(self.analysisY , "gokula")
                        }
                    } catch {
                        print("Error decoding JSON:", error.localizedDescription)
                        print("gokula", String(data: data, encoding: .utf8) ?? "Data could not be converted to UTF-8 string")
                    }
                }.resume()
            }

}
