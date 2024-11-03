//
//  BroadcastRow.swift
//  AutocommentIq-ios
//
//  Created by Gokula Krishnan R on 06/04/24.
//

import SwiftUI

struct BroadcastRow: View {
    let broadcast: BroadcastT
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: "\(broadcast.thumbnail)"))
                .scaledToFill()
                .frame(maxHeight: 200)
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(broadcast.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(broadcast.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.3))
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding(.vertical, 8)
    }
}


