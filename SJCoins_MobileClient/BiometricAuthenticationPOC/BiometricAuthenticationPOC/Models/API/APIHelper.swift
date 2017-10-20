//
//  APIHelper.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/20/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import Foundation

class APIHelper {
    typealias Response = (Data?, URLResponse?, Error?)
    typealias CallBack = (Response) -> ()
    
    // MARK: Sesion configuration
    static let customSession: URLSession = {
        //Session configuration
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30 //seconds
        configuration.timeoutIntervalForResource = 30 //seconds
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        
        return URLSession(configuration: configuration)
    }()
    
    // MARK: Public methods
    static func sendAsynchronous(_ request: URLRequest, complition: @escaping CallBack)
    {
        customSession.dataTask(with: request) { data, response, error in
            complition((data, response, error))
            }.resume()
    }
    
//    static func processResponse()
}
