//
//  ReplyElements.swift
//  autocommentIq Watch App
//
//  Created by Gokula Krishnan R on 01/04/24.
//

import SwiftUI

struct ReplyElements: View {
    var videoId: String
    // MARK: - Properties
    @State private var replyComment: String = "" // Represents the reply comment entered by the user
    @State private var showAlert = false // Controls the presentation of the confirmation alert
@ObservedObject var postComment = SubmitCommentNetwork()
    // MARK: - Body
    var body: some View {
        HStack {
            TextField(
                "Enter a reply comment", // Placeholder text for the text field
                text: $replyComment // Binds the text field to the 'replyComment' state variable
            )
            .autocorrectionDisabled(false)
            .onSubmit {
                showAlert = true // Show confirmation alert when the user submits the reply comment
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Submit Comment"), // Title of the confirmation alert
                message: Text("Are you sure you want to submit the comment: '\(replyComment)'?"), // Message asking for confirmation
                primaryButton: .default(Text("Yes")) {
                    
                    postComment.postComment(replyText: replyComment, parentId: videoId) { value in
                        print("working Comment Posted ",  value)
                    }
                    print("Comment submitted: \(replyComment)") // Action when user confirms comment submission
                    // Perform additional actions if needed
                },
                secondaryButton: .cancel(Text("No")) // Cancel action for the confirmation alert
            )
        }
    }
}


