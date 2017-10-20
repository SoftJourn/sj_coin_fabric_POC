//
//  APIComponents.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/13/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

//import Foundation

// Result enum, error enum

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

enum Code: Int {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case internalServerError = 500
    
    func description() -> String {
        switch self {
        case .badRequest: return ""
        case .unauthorized: return ""
        case .forbidden: return ""
        case .notFound: return ""
        case .internalServerError: return ""
        }
    }
}



