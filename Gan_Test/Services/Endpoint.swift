//
//  Endpoint.swift
//  Gan_Test
//
//  Created by Clive Brown on 09/09/2020.
//  Copyright © 2020 Clive Brown. All rights reserved.
//

import Foundation

enum Endpoint {
    private enum HTTPMettod: String {
        case get
        case put
        case post
        case delete
    }
    
    private var baseURL: URL {
        guard let baseURL = URL(string: Constants.baseUrl) else {
            fatalError("baseURL is invalid")
        }
        
        return baseURL
    }
    
    private var method: HTTPMettod {
        switch self {
        case .getCharacters:
            return .get
        }
    }
    
    private var path: String {
      
        switch self {
        case .getCharacters:
            return "characters"
        }
    }
    
    func asUrlRequest() throws -> URLRequest {
        
        guard let requestURL = URL(string: "\(baseURL.absoluteString)\(path)") else {
            throw NetworkError.invalidURL
        }
        
        print(requestURL)
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        
        return request
    }
    
    case getCharacters
}
