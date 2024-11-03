//
//  MultiNoteView.swift
//  notes-app
//
//  Created by Gokula Krishnan R on 09/01/24.
//

import SwiftUI

struct MultiNoteView: View {
    var body: some View {
        VStack{
            HStack{
                HStack{
                    
                    
                    HStack{
                        VStack {
                            Text("🤓")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(55)
                        VStack(alignment: .leading){
                            Text("5 Notes")
                                .font(.system(size:12 , weight: .regular))
                                .foregroundColor(Color(red: 0.41, green: 0.39, blue: 0.34))
                            Text("My Lectures")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                    }
                    Spacer()
                    VStack {
                        
                        Image(systemName: "heart")
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color(red: 0.91, green: 0.88, blue: 0.75))
                    .cornerRadius(65)
                }
                .padding(.vertical , 25)
                .padding(.horizontal , 22)
                }
            .background(Color(red: 0.96, green: 0.93, blue: 0.79))
            .cornerRadius(34)
            .frame(maxWidth: .infinity)
            
        }
    }
}

#Preview {
    ContentView()
}
