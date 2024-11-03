//
//  subcount.swift
//  autocommentIq Watch App
//
//  Created by Gokula Krishnan R on 01/04/24.
//

import Foundation


// Websocket.swift

import Foundation

class Websocket: ObservableObject {
    @Published var messages = [SubCountModel]()
    
    private var webSocketTask: URLSessionWebSocketTask?
    
    init() {
        self.connect()
        self.sendMessage("subCount:UCX6OQ3DkcsbYNE6H8uQQuVA")
    }
    
    private func connect() {
        guard let url = URL(string: "ws://localhost:3002/") else { return }
        let request = URLRequest(url: url)
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        self.receiveMessage()
        webSocketTask?.resume()
    }
    
    private func receiveMessage() {
            webSocketTask?.receive { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    // Handle disconnection or error
                case .success(let message):
                    DispatchQueue.main.async {
                        switch message {
                        case .string(let text):
                            do {
                                let jsonData = Data(text.utf8)
                                let subCountModel = try JSONDecoder().decode(SubCountModel.self, from: jsonData)
                                print("working" ,   self.messages )
                                self.messages = [subCountModel]                                // Call receiveMessage again to continuously receive messages
                                self.receiveMessage()
//                                print(subCountModel)
                            } catch {
                                print("Error decoding JSON:", error.localizedDescription)
                            }
                        case .data(let data):
                            // Handle binary data
                            print("Received binary data:", data)
                        @unknown default:
                            break
                        }
                    }
                }
            }
        }

    func sendMessage(_ message: String) {
        guard let data = message.data(using: .utf8) else { return }
        webSocketTask?.send(.string(message)) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Comment
struct SubCountModel: Codable {
    let t: Int
    let counts: [Count]
    let user: [User]
}

// MARK: - Count
struct Count: Codable {
    let value: String
    let count: Int
}

// MARK: - User
struct User: Codable {
    let value: String
    let count: String
}
