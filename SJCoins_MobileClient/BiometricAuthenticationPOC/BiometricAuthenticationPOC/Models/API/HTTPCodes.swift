//
//  HTTPCodes.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/24/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

enum Code: Int {
    
    // Informational
    case continueCode = 100
    case switchingProtocols = 101
    case processing = 102
    
    // Success
    case ok = 200
    case created = 201
    case accepted = 202
    case nonAuthoritativeInformation = 203
    case noContent = 204
    case resentContent = 205
    case partialContent = 206
    case multiStatus = 207
    case alreadyReported = 208
    case iMUsed = 226
    
    // Redirection
    case multipleChoices = 300
    case movedPermanently = 301
    case found = 302
    case seeOther = 303
    case notModified = 304
    case useProxy = 305
    case temporaryRedirect = 307
    case permanentRedirect = 308
    
    // Client error
    case badRequest = 400
    case unauthorized = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406
    case proxyAuthenticationRequired = 407
    case requestTimeout = 408
    case conflict = 409
    case gone = 410
    case lengthRequired = 411
    case preconditionFailed = 412
    case payloadTooLarge = 413
    case urlTooLong = 414
    case unsupportedMediaType = 415
    case rangeNotSatisfiable = 416
    case expectationFailed = 417
    case imATeapot = 418
    case misdirectedRequest = 421
    case unprocessableEntity = 422
    case locked = 423
    case failedDependency = 424
    case upgradeRequired = 426
    case preconditionRequired = 428
    case tooManyRequests = 429
    case requestHeaderFieldsTooLarge = 431
    case unavailableForLegalReasons = 451
    
    // Server error
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case httpVersionNotSupported = 505
    case variantAlsoNegotiates = 506
    case insufficientStorage = 507
    case loopDetected = 508
    case bandwidthLimitExceeded = 509
    case notExtended = 510
    case networkAuthenticationRequired = 511

    
//    func description() -> String {
//        switch self {
//        case .informationalUnknown:
//            <#code#>
//        case .continueCode:
//            <#code#>
//        case .switchingProtocols:
//            <#code#>
//        case .processing:
//            <#code#>
//        case .ok:
//            <#code#>
//        case .created:
//            <#code#>
//        case .accepted:
//            <#code#>
//        case .nonAuthoritativeInformation:
//            <#code#>
//        case .noContent:
//            <#code#>
//        case .resentContent:
//            <#code#>
//        case .partialContent:
//            <#code#>
//        case .multiStatus:
//            <#code#>
//        case .alreadyReported:
//            <#code#>
//        case .iMUsed:
//            <#code#>
//        case .badRequest:
//            <#code#>
//        case .unauthorized:
//            <#code#>
//        case .paymentRequired:
//            <#code#>
//        case .forbidden:
//            <#code#>
//        case .notFound:
//            <#code#>
//        case .methodNotAllowed:
//            <#code#>
//        case .expectationFailed:
//            <#code#>
//        }
//    }
}
