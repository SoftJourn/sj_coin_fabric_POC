//
//  UserDefaults+SwiftyUserDefaults.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/25/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let user = DefaultsKey<String>("loggedUser")
}

//extension UserDefaults {
//    subscript(key: DefaultsKey<RegisterResponseBody>) -> RegisterResponseBody {
//        get { return unarchive(key)! }
//        set { archive(key, newValue) }
//    }
//}

