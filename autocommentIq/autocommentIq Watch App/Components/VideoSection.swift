//
//  VideoSection.swift
//  autocommentIq Watch App
//
//  Created by Gokula Krishnan R on 01/04/24.
//

import SwiftUI


struct VideoSection: View {
    var video: Video

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(video.title)
                .font(.system(size: 14))
                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                .fontWeight(.bold)
            RemoteImage(url: video.thumbnailURL)
                .aspectRatio(contentMode: .fill)
                .frame(height: 100)
                .clipped()
                .cornerRadius(10)
//            Text(video.description)
//                .font(.caption)
//                .foregroundColor(.secondary)
        }
        .padding(10)
        .background(Color.gray.opacity(0.30))
        .cornerRadius(24)
        .shadow(radius: 5)
    }
}



struct RemoteImage: View {
    let url: String

    var body: some View {
        if let imageUrl = URL(string: url), let imageData = try? Data(contentsOf: imageUrl), let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            Image(systemName: "photo")
                .resizable()
        }
    }
}



#Preview {
    ContentView()
}
