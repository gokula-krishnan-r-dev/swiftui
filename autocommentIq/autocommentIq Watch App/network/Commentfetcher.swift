//
//  Commentfetcher.swift
//  autocommentIq Watch App
//
//  Created by Gokula Krishnan R on 30/03/24.
//

import Foundation
import Combine

class CommentFetcher: ObservableObject {
    @Published var data: [CommentElement] = []
    @Published var autoreply: String?
   
    
    func fetchData(videoId: String) {
        guard let url = URL(string: "http://localhost:3000/v1/negative/comment-ios?videoId=\(videoId)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let comments = try JSONDecoder().decode(CommentBox.self, from: data)
                DispatchQueue.main.async {
                    self.data = comments.comments
                    
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func refetchData(pageToken: String? = nil , videoId: String) {
        var urlString = "http://localhost:3000/v1/negative/comment-ios?videoId=\(videoId)"
          if let token = pageToken {
              urlString += "&pageToken=\(token)"
          }
          
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let comments = try JSONDecoder().decode(CommentBox.self, from: data)
                DispatchQueue.main.async {
                    self.data.append(contentsOf: comments.comments)
                    print(self.data)
                    
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    
    func fetchAutoreply(message: String) {
           guard let url = URL(string: "http://localhost:3000/api/llama2?message=\(message)") else { return }

           URLSession.shared.dataTask(with: url) { data, response, error in
               guard let data = data else { return }
               do {
                   let autoreplyResponse = try JSONDecoder().decode(AutoreplyResponse.self, from: data)
                   DispatchQueue.main.async {
                       self.autoreply = autoreplyResponse.response
                       print(autoreplyResponse)
                   }
               } catch {
                   print(error.localizedDescription)
               }
           }.resume()
       }
}

struct AutoreplyResponse: Codable {
    let response: String
}
// MARK: - Comment
struct CommentBox: Codable {
    let comments: [CommentElement]
}

struct CommentElement: Codable, Identifiable {
    let id = UUID()
    let textOriginal: String
    let authorDisplayName: String
    let authorProfileImageURL: String
    let channelID: String
    let videoID: String
    let likeCount: String
    let publishedAt: String
    let updatedAt: String
    let replieCount: Int?
    let replies: [CommentElement]?
    let nextPageToken: String?
    let parentId: String?


    enum CodingKeys: String, CodingKey {
        case textOriginal, authorDisplayName
        case authorProfileImageURL = "authorProfileImageUrl"
        case channelID = "channelId"
        case videoID = "videoId"
        case likeCount, publishedAt, updatedAt, replieCount, replies, nextPageToken, parentId
    }
}




