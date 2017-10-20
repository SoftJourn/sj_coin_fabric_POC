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
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var signInButton: UIButton!
    
    // MARK: Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        configureNavigationBar()
    }
    
    deinit {
        debugPrint("\(InitialViewController.self) DELETED.")
    }
    
    // MARK: Actions
    @IBAction private func signUpButtonPressed(_ sender: UIButton) {
        Navigator(navigationController).pushSignUpScreen()
    }
    
    @IBAction private func signInButtonPressed(_ sender: UIButton) {
        Navigator(navigationController).pushSignInScreen()
    }
    
    private func configureButtons() {
        signInButton.layer.borderWidth = 1
        signInButton.layer.borderColor = UIColor(red: CGFloat(49)/255, green: CGFloat(170)/255, blue: CGFloat(255)/255, alpha: 1.0).cgColor
    }
    
    private func configureNavigationBar() {
        guard let bar = navigationController?.navigationBar else { return }
        bar.shadowImage = UIImage()
        bar.setBackgroundImage(UIImage(), for: .default)
    }
}
