//
//  RegisterResponseBody.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/25/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import Foundation

struct RegisterResponseBody: Codable {
    let email: String
    let firstName: String
    let lastName: String
    let personId: String
}
