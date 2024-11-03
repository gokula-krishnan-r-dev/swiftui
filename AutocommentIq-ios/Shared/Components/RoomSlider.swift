//
//  RoomSlider.swift
//  AutocommentIq-ios
//
//  Created by Gokula Krishnan R on 08/04/24.
//
import SwiftUI

struct RoomSlider: View {
    @ObservedObject var viewModel = RoomViewModel()
    @State private var selectedRoom: Room? = nil
    var body: some View {
        VStack{
                HStack{
                    Text("Chating room")
                        .font(.system(size: 16))
                    Spacer()
                    NavigationLink(destination: ListChat(rooms: viewModel.rooms)) {
                        Text("More")
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(55)
                    }
                    .buttonStyle(.plain)
                }
            
            if  self.viewModel.rooms.isEmpty {
                Text("No Rooms ")
            }else{
                
                GeometryReader { geometry in
                    TabView {
                        ForEach(viewModel.rooms, id: \.roomId) { room in
                            VStack {
                                ZStack(alignment: .bottomLeading) {
                                    RemoteImage(url: room.videoThumbnail)
                                        .frame(width: geometry.size.width, height: 140)
                                       
                                    
                                    Text(room.videoTitle)
                                        .font(.system(size: 8))
                                        .foregroundColor(.white)
                                        .padding(4)
                                        .background(Color.black.opacity(0.5))
                                        .cornerRadius(4)
                                        .lineLimit(1)
                                        .padding([.leading, .bottom], 16)
                                }
                            }
                            .cornerRadius(24)
                            .frame(width: geometry.size.width , height: 100)
                            .onTapGesture {
                                self.selectedRoom = room
                            }
                            .sheet(item: self.$selectedRoom) { room in
                                RoomDetailView(room: room)
                            }
                        }
                    }
                }
//                .onAppear{
//                    self.selectedRoom = viewModel.rooms.first
//                }
                .frame(height: 150) // Adjust height as needed
            }
        }
    }
}



