//
//  Videofetcher.swift
//  autocommentIq Watch App
//
//  Created by Gokula Krishnan R on 01/04/24.
//

import Foundation


class Videofetcher: ObservableObject {
    @Published var videos: VideoT?
    
    func fetchVideo() {
        guard let url = URL(string: "http://localhost:3000/v1/watchos/video?videoId=sd") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
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
                let video = try decoder.decode(VideoT.self, from: data)
                DispatchQueue.main.async {
                    self.videos = video
                }
            } catch {
                print("Error decoding JSON:", error.localizedDescription)
                print("Response Data:", String(data: data, encoding: .utf8) ?? "Data could not be converted to UTF-8 string")
            }
        }.resume()
    }

}


// MARK: - Comment
struct VideoT: Codable {
    let nextPageToken: String
    let videos: [Video]
}

// MARK: - Video
struct Video: Codable , Hashable {
    let title: String
    let thumbnailURL: String
    let publishTime: Date
    let description: String
    let totalResults: Int
    let videoID, channelID, channelTitle: String

    enum CodingKeys: String, CodingKey {
        case title
        case thumbnailURL = "thumbnailUrl"
        case publishTime, description, totalResults
        case videoID = "videoId"
        case channelID = "channelId"
        case channelTitle
    }
}
