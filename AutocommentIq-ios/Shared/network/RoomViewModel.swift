import Foundation

class RoomViewModel: ObservableObject {
    @Published var rooms = [Room]()
@Published var message = [MessageTElement]()
    init() {
        fetchData()
    }

    func fetchData() {
        // Replace URLString with your API endpoint
        guard let url = URL(string: "http://localhost:3000/v1/watchos/live-chat-room/UCvrhwpnp2DHYQ1CbXby9ypQ") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data:", error?.localizedDescription ?? "Unknown error")
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(RoomResponse.self, from: data)
                DispatchQueue.main.async {
                    self.rooms = decodedData.room
                    print(self.rooms , "gokula")
                }
            } catch {
                print("Error decoding JSON:", error.localizedDescription)
                print("Response Data:", String(data: data, encoding: .utf8) ?? "Data could not be converted to UTF-8 string")
            }
        }.resume()
    }
    
    func fetchMessage(Id: String) {
        guard let url = URL(string: "http://localhost:3000/api/messages/\(Id)") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data:", error?.localizedDescription ?? "Unknown error")
                return
            }

            do {
                let decodedData = try JSONDecoder().decode([MessageTElement].self, from: data)
                DispatchQueue.main.async {
                    self.message = decodedData
                }
            } catch {
                print("Error decoding JSON:", error.localizedDescription)
                print("Response Data:", String(data: data, encoding: .utf8) ?? "Data could not be converted to UTF-8 string")
            }
        }.resume()
    }
    
}

struct RoomResponse: Codable {
    let room: [Room]
}

struct Room: Codable, Identifiable {
    let id, name, roomId, videoId: String
    let onlineUsers: [String]  // Assuming onlineUsers contain user IDs or names
    let isOnline: Bool
    let channelName, channelId, videoTitle: String
    let channelLogo: String
    let videoThumbnail: String
    let isLeft, createdAt, updatedAt: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case roomId = "roomId"
        case videoId = "videoId"
        case onlineUsers, isOnline
        case channelName = "channel_name"
        case channelId = "channel_id"
        case videoTitle = "video_title"
        case channelLogo = "channel_logo"
        case videoThumbnail = "video_thumbnail"
        case isLeft
        case createdAt = "CreatedAt"
        case updatedAt = "UpdatedAt"
        case v = "__v"
    }
}





// MARK: - MessageTElement
struct MessageTElement: Codable {
    let id, message: String
    let roomID: String
    let userID: UserT
    let type: String
    let heart: Bool
    let emotes: [Emote]
    let createdAt, updatedAt: String
    let v: Int
    let replyTo: ReplyTo?
    let replyMessage: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case message
        case roomID = "roomId"
        case userID = "userId"
        case type, heart, emotes, createdAt, updatedAt
        case v = "__v"
        case replyTo, replyMessage
    }
}

// MARK: - Emote
struct Emote: Codable  , Identifiable {
    
    let emoteString: String
    let userID: String
    let user: UserT
    let roomID: String
    var id: String

    enum CodingKeys: String, CodingKey {
        case emoteString
        case userID = "userId"
        case user
        case roomID = "roomId"
        case id = "_id"
    }
}

// MARK: - User
struct UserT: Codable {
    let id: String
    let googleID: String
    let username: String
    let email: String
    let accessToken: String
    let profile: Profile
    let token: String
    let channelID: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case googleID = "googleId"
        case username, email, accessToken, profile, token
        case channelID = "channelId"
        case v = "__v"
    }
}

// MARK: - Profile
struct Profile: Codable {
    let provider: String
    let sub, id: String
    let displayName: String
    let name: NameClass
    let givenName: String
    let familyName: String?
    let emailVerified, verified: Bool
    let language: String
    let email: String
    let emails, photos: [EmailElement]
    let picture: String
    let raw: String
    let profileJSON: JSON

    enum CodingKeys: String, CodingKey {
        case provider, sub, id, displayName, name
        case givenName = "given_name"
        case familyName = "family_name"
        case emailVerified = "email_verified"
        case verified, language, email, emails, photos, picture
        case raw = "_raw"
        case profileJSON = "_json"
    }
}

// MARK: - EmailElement
struct EmailElement: Codable {
    let value: String
    let type: String
}

// MARK: - NameClass
struct NameClass: Codable {
    let givenName: String
    let familyName: String?
}

// MARK: - JSON
struct JSON: Codable {
    let sub: String
    let name: String
    let givenName: String
    let familyName: String?
    let picture: String
    let email: String
    let emailVerified: Bool
    let locale: String

    enum CodingKeys: String, CodingKey {
        case sub, name
        case givenName = "given_name"
        case familyName = "family_name"
        case picture, email
        case emailVerified = "email_verified"
        case locale
    }
}

// MARK: - ReplyTo
struct ReplyTo: Codable {
    let messageID: String
    let username: String

    enum CodingKeys: String, CodingKey {
        case messageID = "messageId"
        case username
    }
}

// MARK: - MessageTType
struct MessageTType: Codable {
    let rawValue: String
}

typealias MessageT = [MessageTElement]
