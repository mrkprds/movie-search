//
//  Constants.swift
//  Optimum Coding Assesment
//
//  Created by Patrick Perdon on 06/11/2024.
//

import Foundation

enum URLConstants {
    
    enum Config: String {
        
        case BASE_URL
        case API_KEY
        
        enum ConfigError: Error {
            case missingKey(String), invalidValue
        }
        
        static func value<T>(for key: Config) throws -> T where T: LosslessStringConvertible {
            guard let object = Bundle.main.object(forInfoDictionaryKey: key.rawValue) else {
                throw ConfigError.missingKey(key.rawValue)
            }

            switch object {
            case let value as T:
                return value
            case let string as String:
                guard let value = T(string) else { fallthrough }
                return value
            default:
                throw ConfigError.missingKey(key.rawValue)
            }
        }
    }
   
    enum Parameters: String {
        case search = "s"
        case searchType = "type"
        case apikey
    }
    
    enum SearchTypes: String {
        case movie, series, episode
    }
    
}

extension URLConstants.Config.ConfigError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidValue:
            return "Invalid configuration value."
        case .missingKey(let key):
            return "Configuration Key: \(key) not found."
        }
    }
}

