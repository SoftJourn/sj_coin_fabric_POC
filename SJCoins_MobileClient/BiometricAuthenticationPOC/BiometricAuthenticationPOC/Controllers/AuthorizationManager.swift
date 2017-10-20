//
//  AuthorizationManager.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/18/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import UIKit

class AuthorizationManager: APIHelper {
    // MARK: Constants
    static let jpegQuality: CGFloat = 0.8
    typealias result = (Result<Any>) -> ()
    
    // MARK: Public methods.
    class func registerRequest(ldap: String, password: String, face: UIImage, complited: result) {
        
        let faceData = UIImageJPEGRepresentation(face, jpegQuality)!
        
        
        var request = URLRequest(url: URL(string: Constants.api.baseURL + "/register")!)
        request.httpMethod = Methods.post.rawValue
        request.httpBody = nil
        //request.addValue("header.value", forHTTPHeaderField: "header.key")

        sendAsynchronous(request) { data, response, error in
            guard let receivedData = data, let receivedResponse = response, error == nil else {
                debugPrint("")
                let error = customError(message: "Server error occured.")
                complited(.failure(""))
                
                complited(nil, )
                return
            }
            
            
        }
        
        //let parameters: Parameters = [ "username" : login, "password" : password, grantTypeKey : "password" ]

    }
    
    class func loginRequest(complited: result) {
        
    }
    
    // MARK: Private methods.
    private class func customError(_ code: Int = 0, message: String) -> Error
    {
        return NSError(domain: "sjbio", code: code, userInfo: [NSLocalizedDescriptionKey : message])
    }
    
//    // MARK: Private methods.
//    private class func handle(_ response: URLResponse, and data: Data) -> Error?
//    {
//        // Print response and body.
//        debugPrint(response)
//        debugPrint("URLResponse body: " + String(data: data, encoding: String.Encoding.utf8)!)
//        // Return Error acording to server response.
//        let statusCode = (response as! HTTPURLResponse).statusCode
//        switch statusCode {
//        case code.notFound.rawValue:
//            return customError(code.notFound.rawValue, message: code.notFound.description())
//        case code.badRequest.rawValue:
//            return customError(code.badRequest.rawValue, message: code.badRequest.description())
//        case code.unauthorized.rawValue:
//            return customError(code.unauthorized.rawValue, message: code.unauthorized.description())
//        case code.forbidden.rawValue:
//            return customError(code.forbidden.rawValue, message: code.forbidden.description())
//        case code.internalServerError.rawValue:
//            return customError(code.internalServerError.rawValue, message: code.internalServerError.description())
//        default:
//            let error = errorSubstitute(from: data)
//            guard error == nil else {
//                return error
//            }
//            return nil
//        }
//    }
}
