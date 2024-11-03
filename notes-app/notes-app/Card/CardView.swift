//
//  CardView.swift
//  notes-app
//
//  Created by Gokula Krishnan R on 09/01/24.
//

import SwiftUI

struct CardView: View {
   
    let customColor = Color(
                red: Double(0xEB) / 255.0,
                green: Double(0x7A) / 255.0,
                blue: Double(0x53) / 255.0
            )

    var body: some View {
     
        VStack(alignment: .leading){
            VStack{
                HStack{
                    VStack{
                        Text("Plan for \nThe Day")
                            .foregroundColor(.black)
                            .font(.headline)
                        
                    }
                  
                    Spacer()
                    
                    VStack {
                        
                        Image(systemName: "heart")
                        .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color(red: 0.87, green: 0.45, blue: 0.31))
                        .cornerRadius(55)
                }
                HStack{
                    Text("Updated 1h ago")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color.primary)
                    
                        
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            
                VStack{
                    CheckBoxView()
                    CheckBoxView()
                }
                
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .frame(width: 188)
        .background(Color(red: 0.92, green: 0.48, blue: 0.33))
        .cornerRadius(34)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ContentView()
}

