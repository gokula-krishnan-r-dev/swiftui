//
//  chatMessage.swift
//  AutocommentIq-ios
//
//  Created by Gokula Krishnan R on 08/04/24.
//

import SwiftUI

struct chatMessage: View {
    var room: Room
    var messages: [MessageTElement]
    
    var body: some View {
        ScrollView {
            ForEach(messages, id: \.id) { message in
                MessageRowView(message: message)
            }
        }
        
    }
}

struct MessageRowView: View {
    var message: MessageTElement
    @State private var isShowingPopup = false
    let popupText: String = "hi"
        
    var body: some View {
        VStack(alignment:.leading) {
            HStack{
                // Avatar image
                RemoteImage(url: message.userID.profile.picture)
                    .frame(width: 28 , height: 28)
                    .clipShape(Circle())
                // Username
                Text(message.userID.username)
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                
            }
            VStack(alignment: .leading) {
                // Message content
                Text(message.message)
            }
            HStack{
                HStack{
                    Text(TimeAgo.timeAgo(dateString: message.createdAt))
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    Spacer()
                    
                
                    Button(action: {
                        self.isShowingPopup = true
                    }) {
                        Text("\(message.emotes.map { "\($0.emoteString)" }.joined(separator: ", "))")
                    }
                    .alert(isPresented: $isShowingPopup) {
                        Alert(
                            title: Text("Popup Title"),
                            message: Text(message.emotes.map { "\($0.user.username): \($0.emoteString)" }.joined(separator: ", ")),
                            dismissButton: .default(Text("Close"))
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(3)
                    
                    Spacer()
                    
                    Text("\(message.emotes.count) likes")
                        .font(.footnote)
                        .fontWeight(.bold)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.3))
        .cornerRadius(15)
        .padding(.horizontal, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
struct TimeAgo {
    static func timeAgo(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let previousDate = dateFormatter.date(from: dateString) else {
            return ""
        }
        
        let currentDate = Date()
        let timeDifference = Int(currentDate.timeIntervalSince(previousDate))
        
        let seconds = timeDifference
        let minutes = seconds / 60
        let hours = minutes / 60
        let days = hours / 24
        let months = days / 30
        let years = months / 12
        
        if seconds < 60 {
            return "\(seconds) sec\(seconds != 1 ? "s" : "") ago"
        } else if minutes < 60 {
            return "\(minutes) min\(minutes != 1 ? "s" : "") ago"
        } else if hours < 24 {
            return "\(hours) hour\(hours != 1 ? "s" : "") ago"
        } else if days < 30 {
            return "\(days) day\(days != 1 ? "s" : "") ago"
        } else if months < 12 {
            return "\(months) month\(months != 1 ? "s" : "") ago"
        } else {
            return "\(years) year\(years != 1 ? "s" : "") ago"
        }
    }
}
