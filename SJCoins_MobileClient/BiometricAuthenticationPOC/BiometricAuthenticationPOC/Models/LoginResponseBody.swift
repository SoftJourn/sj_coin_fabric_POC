//
//  LoginResponseBody.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/26/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import Foundation

struct LoginResponseBody: Codable {
    let email: String
    let firstName: String
    let lastName: String
    let personId: String
    let verifyResponse: Verify
}

struct Verify: Codable {
    let isIdentical: Bool
    let confidence: Float
}
