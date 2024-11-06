//
//  NetworkRequestManager.swift
//  Optimum Coding Assesment
//
//  Created by Patrick Perdon on 06/11/2024.
//

import Foundation
import OSLog

struct NetworkRequestManager {
    
    let scheme: String = "https"
    let baseURL: String
    
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: NetworkRequestManager.self)
    )
    
    enum NetworkRequestError: Error {
        case encodingError(Error)
        case invalidURL
        case cannotParseIntoHTTPURLResponse
        case invalidStatusCode(Int)
        case decodingError
    }
    
    enum HTTPMethod  {
        
        case post(jsonHeader: Encodable?)
        case get
        
        /// Returns the raw string value of the HTTP method.
        var rawValue: String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            }
        }
    }
    
    func sendNetworkRequest<T: Decodable>(
        withParameters parameters: [String: Any] = [:],
        httpMethod: HTTPMethod
    ) async throws -> T {
        
        //Compose URL Components
        var components = URLComponents()
        components.scheme = scheme
        components.host = baseURL
        
        
        //Append parameters if needed
        if !parameters.isEmpty {
            components.queryItems = parameters.map {
                URLQueryItem(
                    name: $0.key,
                    value: "\($0.value)"
                )
            }
        }
        
        logger.log(level: .debug, "Processing URLComponents")
        
        //Validate URL
        guard let url = components.url else {
            throw NetworkRequestError.invalidURL
        }
        
        
        //Create a URL request with the final URL and HTTP method.
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        
        //Attach JSON header if needed
        switch httpMethod {
        case .post(let jsonHeader):
            guard let jsonHeader else { break }
            urlRequest.setValue("text/plain", forHTTPHeaderField: "Content-Type")
            do {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(jsonHeader)
                urlRequest.httpBody = jsonData
            } catch {
                throw NetworkRequestError.encodingError(error)
            }
        default:
            break
        }
        
        
        return try await performNetworkRequest(urlRequest)
    }
    
    private func performNetworkRequest<T: Decodable>(_ urlRequest: URLRequest) async throws -> T {
        
        logger.log(level: .debug, "Starting Network Request")
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        // Validate the HTTP response status code.
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkRequestError.cannotParseIntoHTTPURLResponse
        }
        
        // Check if status code is in successful 2xx range
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkRequestError.invalidStatusCode(httpResponse.statusCode)
        }
        
        logger.log(level: .debug, "Decoding Response")
        
        // Decode the response data to the specified type
        return try JSONDecoder().decode(T.self, from: data)
    }
}
