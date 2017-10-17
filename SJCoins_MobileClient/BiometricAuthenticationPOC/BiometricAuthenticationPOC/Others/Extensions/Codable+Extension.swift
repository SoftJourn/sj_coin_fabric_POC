//
//  Serializable.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/13/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import Foundation

//: Decodable Extension
extension Decodable {
    static func decode(data: Data) throws -> Self {
        let decoder = JSONDecoder()
        return try decoder.decode(Self.self, from: data)
    }
}

//: Encodable Extension
extension Encodable {
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(self)
    }
}

