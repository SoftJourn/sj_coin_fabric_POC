//
//  Register.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/13/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

struct Register: Codable {
    let email: String
    let firstName: String
    let lastName: String
    let personId: String
    let faceId: String
    let persistentFaceId: String
}
