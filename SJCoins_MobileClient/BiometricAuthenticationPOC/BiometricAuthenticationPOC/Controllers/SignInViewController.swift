//
//  SignInViewController.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/17/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    // MARK: Constants
    static let identifier = "\(SignInViewController.self)"
    
    // MARK: Properties
    
    
    // MARK: Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        debugPrint("\(SignInViewController.self) DELETED.")
    }
    
    // MARK: Actions
    @IBAction func withLdapButtonClicked(_ sender: UIButton) {
        Navigator(navigationController).pushLdapSignInScreen()
    }
    
    @IBAction func withFaceButtonClicked(_ sender: UIButton) {
    
    }
    
    // MARK: Private methods
    
    // MARK: Public methods
    
}
