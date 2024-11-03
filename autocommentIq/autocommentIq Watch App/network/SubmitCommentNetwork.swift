//
//  SubmitCommentNetwork.swift
//  autocommentIq Watch App
//
//  Created by Gokula Krishnan R on 01/04/24.
//

import Foundation

class SubmitCommentNetwork: ObservableObject {
    // MARK: - Properties
    var accessToken: String = "ya29.a0Ad52N3-oCZqgqQoBJcOA-_oYc_GsZhzPSHlxuCsnNOlKHsH8Vf5z1D19mWYO3jBKHGyq02nWhPE5HT0xs4LOAzR0C2WIqiDOaqTZBLbRXuYWSrjoQ1eoiTlrJ889ONIAMwSjpsxGsIY1EaRlEKTR7JcAj7o_XNoGMVwaCgYKAVESARASFQHGX2MilrJk4F2peXeMyR3MuRZ1ZA0170"
    
  
    
    // MARK: - Methods
    func postComment(replyText: String, parentId: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let data = [
            
                "textOriginal": replyText,
                "parentId": parentId
            
        ]

        
        guard let url = URL(string: "http://localhost:3000/v1/watchos/comment-video") else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: data, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
//            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
//                let error = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
//                completion(.failure(error))
//                return
//            }
            
            guard let responseData = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            completion(.success(responseData))
            print(response)
        }.resume()
    }
}
