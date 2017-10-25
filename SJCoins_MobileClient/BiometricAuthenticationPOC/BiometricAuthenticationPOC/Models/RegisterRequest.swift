//
//  RegisterRequestBody.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/13/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import Foundation

struct RegisterRequestBody: Codable {
    let username: String
    let password: String
    let imageBytes: Data
    let personGroupId: String
}
