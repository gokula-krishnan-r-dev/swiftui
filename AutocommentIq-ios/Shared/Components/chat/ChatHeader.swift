//
//  ChatHeader.swift
//  AutocommentIq-ios
//
//  Created by Gokula Krishnan R on 08/04/24.
//

import SwiftUI

struct ChatHeader: View {
    var room: Room
    var body: some View {
        HStack{
            RemoteImage(url: room.channelLogo)
                .frame(width: 16 , height: 16)
                .clipShape(Circle())
            VStack {
                Text(room.videoTitle)
                    .font(.system(size: 8))
                    .lineLimit(1)
            }
            Button(action: {
               print("hi")
               }) {
                   Text("\(room.onlineUsers.count)")
                       .font(.system(size: 10))
                       .foregroundColor(.blue) // Customize the color as needed
                       .padding(5)
                       .background(Color.gray.opacity(0.2)) // Add some background to make it look like a button
                       .cornerRadius(5)
               }
            .buttonStyle(.plain)
        }
    }
}

