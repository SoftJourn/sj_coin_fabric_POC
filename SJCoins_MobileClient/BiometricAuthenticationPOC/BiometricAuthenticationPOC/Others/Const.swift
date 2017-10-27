//
//  Const.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/13/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

struct Constants {
    
    struct key {
        static let models = "models"
        static let user = "user"
    }
    
    struct delay {
        static let success = 0.5
        static let failed = 2.0
    }
    
    struct api {
        static let baseURL = "http://192.168.102.74:3000/api"
    }
}
