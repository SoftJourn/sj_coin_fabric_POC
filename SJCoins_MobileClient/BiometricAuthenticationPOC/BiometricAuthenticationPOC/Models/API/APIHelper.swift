//
//  APIHelper.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/20/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

enum Methods: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class APIHelper {
    
    typealias Response = (Data?, URLResponse?, Error?)
    typealias CallBack = (Result<Any>) -> ()
    
    // MARK: Sesion configuration
    static let customSession: URLSession = {
        //Session configuration
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30    //seconds
        configuration.timeoutIntervalForResource = 30   //seconds
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        
        return URLSession(configuration: configuration)
    }()
    
    // MARK: Public methods
    // Send asynchronous URLRequest
    static func asynch(_ request: URLRequest, complition: @escaping CallBack)
    {
        customSession.dataTask(with: request) { data, response, error in
            complition(handleResponse((data, response, error)))
            }.resume()
    }
    
//    // Send synchronous URLRequest
//    static func synch(request: URLRequest, complition: @escaping CallBack) {
//        let semaphore = DispatchSemaphore(value: 0)
//        customSession.dataTask(with: request) { data, response, error in
//            complition(handleResponse((data, response, error)))
//            semaphore.signal()
//            }.resume()
//        _ = semaphore.wait(timeout: .distantFuture)
//    }
    
    private static func handleResponse(_ response: Response) -> Result<Any> {
        guard let body = response.0, let receivedResponse = response.1, response.2 == nil else {
            debugPrint("Server not respond.")
            return .failure(errorWith(message: "Server error occured."))
        }
        let error = handle(receivedResponse, and: body)
        guard error == nil else { return .failure(error!) }
        return .success(body)
    }
    
    class func errorWith(_ code: Int = 0, message: String) -> Error {
        return NSError(domain: "SJBioPOC", code: code, userInfo: [NSLocalizedDescriptionKey : message])
    }
    
    private class func handle(_ response: URLResponse, and data: Data) -> Error?
    {
        // Print response and body.
        debugPrint(response)
        debugPrint("URLResponse body: " + String(data: data, encoding: String.Encoding.utf8)!)
        // Return Error acording to server response.
        let statusCode = (response as! HTTPURLResponse).statusCode
        switch statusCode {
        case Code.ok.rawValue:
            return nil
        case Code.expectationFailed.rawValue:
            return errorSubstitute(from: data)
        default:
            return errorSubstitute(from: data)
        }
    }
    
    private class func errorSubstitute(from data: Data) -> Error?
    {
        return errorWith(message: String(data: data, encoding: .utf8) ?? "Empty string error.")
        
//        do {
//            guard let json = try JSONSerialization.jsonObject(with: data) as? String else { return nil }
//            return errorWith(message: json)
//        } catch {
//            return nil
//        }
    }
}
