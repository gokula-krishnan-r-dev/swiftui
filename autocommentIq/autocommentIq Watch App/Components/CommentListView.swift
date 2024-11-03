//
//  CommentListView.swift
//  autocommentIq Watch App
//
//  Created by Gokula Krishnan R on 30/03/24.
//

import SwiftUI

struct CommentListView: View {
    let comments: [CommentElement]
    @StateObject var commentFetcher = CommentFetcher()

    var body: some View {
        List {
            ForEach(comments , id: \.id) { comment in
                NavigationLink(destination: CommentDetail(comment: comment , isreply: false)) {
                    CommentRow(comment: comment)
                }
            }
            Button(action: {
                commentFetcher.refetchData(pageToken: comments[0].nextPageToken , videoId: comments[0].videoID)
                           }) {
                               Text("Refetch Comments")
                                   .foregroundColor(.blue)
                           }
                           .frame(width: 100 , height: 30)
        }
        .listStyle(.carousel) // Using DefaultListStyle for watchOS
    }
}



