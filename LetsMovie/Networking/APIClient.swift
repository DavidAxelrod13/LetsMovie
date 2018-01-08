//
//  APIClient.swift
//  LetsMovie
//
//  Created by David on 08/01/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

enum APIError:  Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    
    var locoalizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        }
    }
}

protocol APIClient {
    var session: URLSession { get }
    func fetch<T: Decodable>(withRequest request: URLRequest, decode: @escaping (Decodable) -> T?, onCompletion: @escaping (Result<T, APIError>) -> Void)
}

extension APIClient {
    
    typealias JSONTaskCompletionHandler = (Decodable?, APIError?) -> Void
    
    private func decodingTask<T: Decodable>(withRequest request: URLRequest, decodingType: T.Type, completionHandler onCompletion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        
        print("Visiting URL: ", request.url!, "\n")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                onCompletion(nil, .requestFailed)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                onCompletion(nil, .requestFailed)
                return
            }
            
            if (200...300) ~= httpResponse.statusCode {
                if let data = data {
                    do {
                        let genericModel = try JSONDecoder().decode(decodingType, from: data)
                        onCompletion(genericModel, nil)
                    } catch {
                        onCompletion(nil, .jsonConversionFailure)
                    }
                } else {
                    onCompletion(nil, .invalidData)
                }
            } else {
                onCompletion(nil, .responseUnsuccessful)
            }
        }
        return task
    }
    
    func fetch<T: Decodable>(withRequest request: URLRequest, decode: @escaping (Decodable) -> T?, onCompletion: @escaping (Result<T, APIError>) -> Void) {
        let task = decodingTask(withRequest: request, decodingType: T.self) { (json, error) in
            
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        onCompletion(Result.failure(error: error))
                    } else {
                        onCompletion(Result.failure(error: .invalidData))
                    }
                    return
                }
                if let value = decode(json) {
                    onCompletion(Result.success(value))
                } else {
                    onCompletion(Result.failure(error: .jsonParsingFailure))
                }
            }
        }
        task.resume()
    }
}




