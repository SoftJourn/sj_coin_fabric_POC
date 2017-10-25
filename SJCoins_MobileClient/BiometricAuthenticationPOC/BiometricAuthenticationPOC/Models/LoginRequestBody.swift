//
//  LoginRequestBody.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/25/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import Foundation

struct LoginRequestBody: Codable {
    let username: String?
    let password: String?
    let email: String
    let imageBytes: Data?
}
