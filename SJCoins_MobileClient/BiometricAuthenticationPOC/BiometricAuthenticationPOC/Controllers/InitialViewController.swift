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
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var signInButton: UIButton!
    
    // MARK: Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
    }
    
    deinit {
        debugPrint("\(InitialViewController.self) DELETED.")
    }
    
    // MARK: Actions
    @IBAction private func signUpButtonPressed(_ sender: UIButton) {
        Navigator(navigationController).presentSignUpScreen()
    }
    
    @IBAction private func signInButtonPressed(_ sender: UIButton) {
        Navigator(navigationController).presentSignInScreen()
    }
    
    private func configureButtons() {
        
        let radius = signUpButton.frame.height / 2
        
        signUpButton.layer.cornerRadius = radius
        signInButton.layer.cornerRadius = radius
        signInButton.layer.borderWidth = 1
        
        signInButton.layer.borderColor = UIColor(red: 49, green: 170, blue: 255, alpha: 1).cgColor
    }
}
