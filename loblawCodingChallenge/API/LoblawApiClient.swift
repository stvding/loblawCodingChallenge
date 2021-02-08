//
//  LoblawApiClient.swift
//  loblawCodingChallenge
//
//  Created by tommytexter on 2021-02-06.
//

import Foundation


protocol LoblawApiClientInterface {
    func requestCartInfo(onSuccess: @escaping (Cart) -> Void, onFailure: @escaping (CartRequestError) -> Void)
}

class LoblawApiClient: LoblawApiClientInterface {
    let networkSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    static public let shared: LoblawApiClient = LoblawApiClient()
    private let urlString = "https://gist.githubusercontent.com/r2vq/2ac197145db3f6cdf1a353feb744cf8e/raw/b1e722f608b00ddde138a0eef2261c6ffc8b08d7/cart.json"
    
    func requestCartInfo(onSuccess: @escaping (Cart) -> Void, onFailure: @escaping (CartRequestError) -> Void) {
        dataTask?.cancel()
        
        networkSession.configuration.timeoutIntervalForRequest = 10
        
        guard let url = URL(string: urlString) else { return }
        dataTask =  networkSession.dataTask(with: url) { [weak self] data, response, error in
            
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                let code = (error as NSError).code
                if code == NSURLErrorTimedOut {
                    NSLog("[API] Request timed out")
                    onFailure(CartRequestError.requestTimedOut)
                } else {
                    NSLog("[API] Request failed with error: \(error.localizedDescription)")
                    onFailure(CartRequestError.apiError)
                }
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                NSLog("[API] Request returned an invalid response")
                onFailure(CartRequestError.invalidResponseError)
                return
            }
            
            guard response.statusCode == 200 else {
                NSLog("[API] Request returned an unsupported status code: \(response.statusCode)")
                onFailure(CartRequestError.unsuccessfulStatusCodeError(statusCode: response.statusCode))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(Cart.self, from: data)
                onSuccess(result)
            } catch {
                NSLog("[API] Decoding failed with error: \(error)")
                onFailure(CartRequestError.jsonSerializationError)
            }
        }
        
        dataTask?.resume()
    }
}
