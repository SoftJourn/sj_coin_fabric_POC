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
    static let registredUser = DefaultsKey<RegisterResponseBody?>("registredUser")
    static let libraries = DefaultsKey<[RegisterResponseBody]>("libraries")
}

extension UserDefaults {
    subscript(key: DefaultsKey<RegisterResponseBody>) -> RegisterResponseBody {
        get { return unarchive(key)! }
        set { archive(key, newValue) }
    }
}
