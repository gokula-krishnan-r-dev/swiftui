//
//  CommentDetail.swift
//  autocommentIq Watch App
//
//  Created by Gokula Krishnan R on 30/03/24.
//

import SwiftUI

struct CommentDetail: View {
    var comment: CommentElement
    @ObservedObject var postComment = SubmitCommentNetwork()
    @StateObject private var commentFetcher = CommentFetcher()
    @State private var fullText: String = "This is some editable text..."
    var isreply: Bool
    var body: some View {
        VStack {
            ScrollView {
            HStack{
                AsyncImage(url: URL(string: comment.authorProfileImageURL))
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                Spacer()
                Text(comment.authorDisplayName)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
            }
          
           
                Text(comment.textOriginal)
                    .font(.body)
                    .foregroundColor(.white)
                
                // Optional Binding to unwrap commentFetcher.autoreply
                if let autoreply = commentFetcher.autoreply {
                    Button(action: {
                              print(autoreply)
                        print(comment.parentId)
                        postComment.postComment(replyText: autoreply, parentId: comment.parentId ?? "") { _ in
                            print("working Comment Posted ")
                        }
                          }) {
                              Text(autoreply) // Use the unwrapped autoreply
                                  .foregroundColor(.white)
                          }
                          .buttonBorderShape(.roundedRectangle(radius: 12))
                          .cornerRadius(12) // Apply corner radius to the button
                    
                } else {
                    // Handle the case where autoreply is nil
                    Button(action: {
                        // Handle the action when autoreply is nil
                    }) {
                        ProgressView()
                    }
                }
                HStack{
                    ReplyElements(videoId: comment.videoID)
                }
                
                Text("reply Message")
                    .font(.headline)
                    .fontWeight(.bold)
                if let replies = comment.replies {
                                ForEach(replies, id: \.id) { reply in
                                    CommentDetail(comment: reply , isreply:true)
                                }
                            }
                
                
                
            }
            .cornerRadius(5)
            .frame(height: isreply ? .infinity :  150) // Adjust the height according to your needs
            
            
            
            HStack{
                
                Text(comment.updatedAt)
                    .font(.caption2)
                    .foregroundColor(.gray)
                Spacer()
                Text("\(comment.likeCount) likes")
                    .font(.footnote)
                    .fontWeight(.bold)
            }
        }
        .onAppear{
            commentFetcher.fetchAutoreply(message: comment.textOriginal)
        }
        .padding(.horizontal , 8)
        .navigationBarTitle("Comment Detail") // Set the navigation title here
    }
}
struct ContentViPreviews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


