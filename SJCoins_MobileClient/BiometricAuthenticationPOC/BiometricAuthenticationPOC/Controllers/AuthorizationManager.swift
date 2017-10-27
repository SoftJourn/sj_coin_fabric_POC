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
    class func registerRequest(ldap: String, password: String, face: UIImage, complited: @escaping result) {
        
        let bodyStruct = RegisterRequestBody(username: ldap, password: password, imageBytes: UIImageJPEGRepresentation(face, jpegQuality)!, personGroupId: "1")
        
        var request = URLRequest(url: URL(string: Constants.api.baseURL + "/register")!)
        request.httpMethod = Methods.post.rawValue
        request.httpBody = try! bodyStruct.encode()
        asynch(request) { result in
            switch result {
            case .success(let data):
                // Create model object
                let registerModel = try! RegisterResponseBody.decode(data: data as! Data)
                complited(.success(registerModel))
            case .failure:
                complited(result)
            }
        }
    }
    
    class func loginRequest(ldap: String?, password: String?, email: String, face: UIImage?, complited: @escaping result) {

        let bodyStruct = LoginRequestBody(username: ldap, password: password, email: email, imageBytes: UIImageJPEGRepresentation(face ?? UIImage(), jpegQuality))
        
        var request = URLRequest(url: URL(string: Constants.api.baseURL + "/login")!)
        request.httpMethod = Methods.post.rawValue
        request.httpBody = try! bodyStruct.encode()
        asynch(request) { result in
            switch result {
            case .success(let data):
                // Create model object
                let loginModel = try! LoginResponseBody.decode(data: data as! Data)
                complited(.success(loginModel))
            case .failure:
                complited(result)
            }
        }
    }
}
