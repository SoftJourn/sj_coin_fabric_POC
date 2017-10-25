//
//  FaceSignInViewController.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/25/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class FaceSignInViewController: UIViewController {
    
    // MARK: Constants
    static let identifier = "\(FaceSignInViewController.self)"
    
    // MARK: Properties
    
    
    // MARK: Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = UserDefaults.standard.value(forKey:"models") as? Data {
            let users = try? PropertyListDecoder().decode(Array<RegisterResponseBody>.self, from: data)
            debugPrint(users ?? "")
        }
        
    }
    
    deinit {
        debugPrint("\(FaceSignInViewController.self) DELETED.")
    }
    
    // MARK: Actions
    
    // MARK: Private methods
    
    // MARK: Public methods
    
}
