//
//  Interactor.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/17/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import Foundation

class Interactor {
    
    // MARK: Properties
    private var delegate: InteractionDelegate?
    
    init(delegate: InteractionDelegate? = nil) {
        self.delegate = delegate
    }
    
    deinit {
        debugPrint("\(Interactor.self) DELETED.")
    }
}
