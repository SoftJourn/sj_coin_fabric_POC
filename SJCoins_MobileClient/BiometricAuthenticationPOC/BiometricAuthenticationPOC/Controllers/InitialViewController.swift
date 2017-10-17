//
//  InitialViewController.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/17/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    // MARK: Constants
    static let identifier = "\(InitialViewController.self)"
    
    // MARK: Properties

    // MARK: Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    deinit {
        debugPrint("\(InitialViewController.self) DELETED.")
    }
}
