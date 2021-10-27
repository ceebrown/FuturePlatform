//
//  NetworkService.swift
//  Gan_Test
//
//  Created by Clive Brown on 09/09/2020.
//  Copyright © 2020 Clive Brown. All rights reserved.
//

import Foundation

protocol NetworkService {
    func getCharacters(_ onComplete: @escaping  ((Result<[Character]>) -> ()))
}

enum Result<T> {
    case success(T)
    case failure(Error)
}

struct NetworkManager: NetworkService {
    private let provider = NetworkProvider()
    private let decoder = JSONDecoder()
       
    func getCharacters(_ onComplete: @escaping ((Result<[Character]>) -> ())) {
        provider.requestArray(.getCharacters) { result in
            self.decodeResult(result, type: Array<Character>.self,onComplete: onComplete)
        }
    }
    
    private func decodeResult<T: Codable>(_ result: Result<Data>, type: T.Type, onComplete: @escaping ((Result<T>) -> ())) {
        
        switch result {
        case .success(let data):
            do {
                let typedResult = try self.decoder.decode(type, from: data)
                
                DispatchQueue.main.async {
                    onComplete(.success(typedResult))
                }
            } catch {
                DispatchQueue.main.async {
                    print(error)
                    onComplete(.failure(error))
                }
            }
        case .failure(let error):
            DispatchQueue.main.async {
                onComplete(.failure(error))
            }
        }
    }
}

private class NetworkProvider {
    
    private let defaultSession = URLSession(configuration: .default)
    
    private var dataTask: URLSessionDataTask?
    
    func requestArray(_ endpoint: Endpoint, onComplete: @escaping ((Result<Data>) -> ())) {
        dataTask?.cancel()
        
        do {
            let request = try endpoint.asUrlRequest()
            dataTask = defaultSession.dataTask(with: request) { data, response, error in
                if let error = error {
                    onComplete(.failure(error))
                } else {
                    guard let data = data else {
                        return onComplete(.failure(NetworkError.incorrectResultType))
                    }
                
                    onComplete(.success(data))
                }
            }
            
            dataTask?.resume()
        } catch {
            onComplete(.failure(error))
        }
    }
}

