//
//  httpService.swift
//  Allume moi
//
//  Created by baboulinet on 10/04/2023.
//

import Foundation

public enum HTTPMethod: String {
    
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}


class HTTPService {
    
    private var originalUrl: URL
    
    init() {
        self.originalUrl = URL(string: "https://jallume.fr/")!
    }
    
    func get(_ path: String, handler completion: (Bool, Data) -> Void) {
        
    }
    
    func post(_ path: String, _ bodyParameters: Data, handler completion: @escaping (_ success: Bool, _ data: Any) -> Void) {
        // Creating the http query
        let postUrl = self.originalUrl.appending(path: path)
        var urlRequest = URLRequest(url: postUrl)
        
        // Setting http headers
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = bodyParameters
        // Defining the task
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(false, "Not working")
                return
            }
        }
        
        // Running the task
        task.resume()
    }
}
