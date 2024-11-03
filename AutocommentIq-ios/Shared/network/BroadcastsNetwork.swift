//
//  BroadcastsNetwork.swift
//  AutocommentIq-ios
//
//  Created by Gokula Krishnan R on 05/04/24.
//

import Foundation
import SwiftUI

class BroadcastsNetwork: ObservableObject {
    @Published var broadcasts: [BroadcastT]?
    @Published var chatMessage: [LiveChatMessageItem]?
    @AppStorage("accessToken") var accessToken: String?
    func fetchBroadcast() {
        guard let url = URL(string: "http://localhost:3000/v1/watchos/broadcasts?part=snippet,id,contentDetails,status,monetizationDetails&id=9DhKFzbaXn4") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add your authentication token here
        let authToken = accessToken
        request.setValue("Bearer \(String(describing: authToken))", forHTTPHeaderField: "Authorization")
        
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
                let video = try decoder.decode([BroadcastT].self, from: data)
                DispatchQueue.main.async {
                    self.broadcasts = video
//                    print(self.broadcasts)
                }
            } catch {
                print("Error decoding JSON:", error.localizedDescription)
                print("Response Data:", String(data: data, encoding: .utf8) ?? "Data could not be converted to UTF-8 string")
            }
        }.resume()
    }
    func fetchLiveChat(id: String) {
        guard let url = URL(string: "http://localhost:3000/v1/watchos/live-chat?liveChatId=\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        

        
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
                let video = try decoder.decode([LiveChatMessageItem].self, from: data)
                DispatchQueue.main.async {
                    self.chatMessage = video
                    print(self.chatMessage)
                }
            } catch {
                print("Error decoding JSON:", error.localizedDescription)
                print("Response Data:", String(data: data, encoding: .utf8) ?? "Data could not be converted to UTF-8 string")
            }
        }.resume()
    }
    struct ChatMessage: Codable {
        let liveChatId: String
        let message: String
    }
    func postMessageToLiveChat(liveChatId: String, message: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let url = URL(string: "http://localhost:3000/v1/live-stream/chat")! // Replace YOUR_PORT with the port number of your local server
        let body = ChatMessage(liveChatId: liveChatId, message: message)
        let jsonData = try! JSONEncoder().encode(body)
        let accessToken = "ya29.a0Ad52N3-r_ZXuU31PzDIfgEtscjBwbwFXildo_iJbquXV0lmYxjJQnSePm0H5bpytfp6c1eCVwDxfGA_2ZVkOqIJnOIugF_d__mKbYqOUUBhg1Mw2CUR0K5k3cnT7tdl5dgpb5WqJkvr1IZ76b56Dcgrvtkd1eh4hDaQaCgYKASgSARASFQHGX2MiEUbDUs9oAyZlGRqZOlh7CQ0170"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization") // Set the access token in the Authorization header
          
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
    
}



struct LiveChatMessageItem: Codable {
    let id: String
    let authorDetails: AuthorDetails
    let snippet: LiveChatMessageSnippet
    let nextPageToken: String
}

struct AuthorDetails: Codable {
    let channelId: String
    let channelUrl: String
    let displayName: String
    let profileImageUrl: String
    let isVerified: Bool
    let isChatOwner: Bool
    let isChatSponsor: Bool
    let isChatModerator: Bool
}

struct LiveChatMessageSnippet: Codable {
    let type: String
    let liveChatId: String
    let authorChannelId: String
    let publishedAt: String
    let hasDisplayContent: Bool
    let displayMessage: String
    let textMessageDetails: TextMessageDetails
}

struct TextMessageDetails: Codable {
    let messageText: String
}


struct BroadcastT: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let thumbnail: URL
    let scheduledStartTime: Date
    let status: Status
    let contentDetails: ContentDetails
    let liveChatId: String

    struct Status: Codable, Identifiable {
        let id = UUID()
        let lifeCycleStatus: String
        let privacyStatus: String
        let recordingStatus: String
        let madeForKids: Bool
        let selfDeclaredMadeForKids: Bool
    }

    struct ContentDetails: Codable, Identifiable {
        let id = UUID()
        let boundStreamId: String
        let boundStreamLastUpdateTimeMs: Date
        let monitorStream: MonitorStream
        let enableEmbed: Bool
        let enableDvr: Bool
        let enableContentEncryption: Bool
        let startWithSlate: Bool
        let recordFromStart: Bool
        let enableClosedCaptions: Bool
        let closedCaptionsType: String
        let enableLowLatency: Bool
        let latencyPreference: String
        let projection: String
        let enableAutoStart: Bool
        let enableAutoStop: Bool

        struct MonitorStream: Codable, Identifiable {
            let id = UUID()
            let enableMonitorStream: Bool
        }
    }
}
