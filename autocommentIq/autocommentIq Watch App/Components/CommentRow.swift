//
//  CommentRow.swift
//  autocommentIq Watch App
//
//  Created by Gokula Krishnan R on 30/03/24.
//

import SwiftUI

struct CommentRow: View {
    var comment: CommentElement

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 4){
                AsyncImage(url: URL(string: comment.authorProfileImageURL))
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                Text("\(comment.likeCount) likes")
                    .font(.system(size: 10))
                    .fontWeight(.bold)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(comment.authorDisplayName)
                    .font(.footnote)
                    .fontWeight(.bold)
                
                Text(comment.textOriginal)
                    .font(.system(size: 14))
                    .lineLimit(4)
                
                Text(comment.updatedAt)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
            
        }
        .padding(8)
        .cornerRadius(12)
        .shadow(radius: 2)
        .frame(height: 100)
    }
}

