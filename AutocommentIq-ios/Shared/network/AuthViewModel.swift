//
//  AuthViewModel.swift
//  AutocommentIq-ios
//
//  Created by Gokula Krishnan R on 12/04/24.
//

import Foundation
import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = true
    @AppStorage("accessToken") var accessToken: String?
    @AppStorage("userId") var userId: String?
       
    init() {
        checkAuthentication()
    }
    
    func checkAuthentication() {
        // Dummy check for authentication
        // Replace this with actual authentication logic
        isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
    }
    func login(otp: String) {
            guard let url = URL(string: "http://localhost:3000/auth/verify/otp") else {
                print("Invalid URL")
                return
            }
            
            let payload = ["otp": otp]
            guard let data = try? JSONEncoder().encode(payload) else {
                print("Error: Unable to encode data")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let data = data, error == nil else {
                    print("Network request failed: \(error?.localizedDescription ?? "No error description")")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    do {
                        let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                        DispatchQueue.main.async {
                            self?.accessToken = response.accessToken
                            self?.userId = response.userId
                            
                            self?.isAuthenticated = true
                        }
                    } catch {
                        print("JSON decoding failed: \(error)")
                    }
                } else {
                    print("HTTP Request failed: \(response.debugDescription)")
                }
            }.resume()
        }
//    func login() {
//        
//        // Example function to simulate logging in
//        UserDefaults.standard.set(true, forKey: "isAuthenticated")
//        isAuthenticated = true
//    }
    
    func logout() {
        // Example function to simulate logging out
        UserDefaults.standard.set(false, forKey: "isAuthenticated")
        isAuthenticated = false
    }
}



// Define the response structure you expect from the server
struct LoginResponse: Codable {
    var message: String
    var userId: String
    var accessToken: String
    var channelId: String
    var token: String
}
