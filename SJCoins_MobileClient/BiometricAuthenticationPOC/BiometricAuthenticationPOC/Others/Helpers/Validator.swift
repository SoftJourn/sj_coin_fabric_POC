//
//  Validator.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/19/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import Foundation

enum validationStatus {
    case success
    case failure
}

class Validator {
    
    // MARK: Class Methods
    class func validate(_ string: String) -> validationStatus {
        return string.isEmpty ? .failure : .success
    }
}
