//
//  SubCount.swift
//  autocommentIq Watch App
//
//  Created by Gokula Krishnan R on 01/04/24.
//

import SwiftUI

struct SubCount: View {
    @StateObject var websocket = Websocket()
    
    var body: some View {
        VStack(alignment: .leading){
            HStack (alignment: .top) {
//                AsyncImage(url: URL(string: "\(websocket.messages.first?.user.indices.contains(1) ?? false ? websocket.messages.first?.user[1].count ?? "channel Name" : "channel Name")")) { phase in
//                             if let image = phase.image {
//                                 image
//                                     .resizable()
//                                     .aspectRatio(contentMode: .fit)
//                                     .frame(width: 33, height: 33)
//                                     .clipShape(Circle())
//                             } else if phase.error != nil {
//                                 Image(systemName: "heart")
//                                     .frame(width: 33, height: 33)
//                             } else {
//                                 ProgressView()
//                             }
//                         }
                         
                AsyncImage(url: URL(string: "https://yt3.ggpht.com/T9IuKawbxOW0FXuRNNUbQaZPC7VuNu-GXW4lDLCW6-kKqFaCQViXgVUpB_fzaslXU-c1W3W-=s800-c-k-c0x00ffffff-no-rj")) { phase in
                                  switch phase {
                                  case .success(let image):
                                      image
                                          .resizable()
                                          .aspectRatio(contentMode: .fit)
                                          .frame(width: 84, height: 84)
                                          .clipShape(Circle())
                                  case .failure(let error):
                                      // Handle image loading failure
                                      Text("Failed to load image: \(error.localizedDescription)")
                                          .foregroundColor(.red)
                                 
                                  case .empty:
                                      ProgressView()
                                  @unknown default:
                                      EmptyView()
                                  }
                              }
                
                Spacer()
                
                AsyncImage(url: URL(string: "https://www.freeiconspng.com/thumbs/youtube-logo-png/youtube-logo-icon-symbol-18.png")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 33, height: 33)
                            .clipShape(Circle())
                    } else if phase.error != nil {
                        Image(systemName: "heart")
                            .frame(width: 33, height: 33)
                    } else {
                        ProgressView()
                    }
                }
              
            }
        
            Text("\(websocket.messages.first?.user.first?.count ?? "channel Name")")
                          .font(.headline)
                      
            HStack {
                Text("\(self.websocket.messages.first?.counts.first?.count ?? 0)")
                                   .font(.system(size: 20))
                                   .fontWeight(.bold)
                                   .foregroundStyle(.red)
            }
            
            Text("Total Subscribers")
                .font(.system(size: 12))
        }
        .onAppear{
//            print("UI" , self.websocket.messages)
            self.websocket.objectWillChange.send()
        }
     
        .padding(14)
        .background(Color.gray.opacity(0.3))
        .cornerRadius(22)
    }
}

#Preview {
    ContentView()
}
