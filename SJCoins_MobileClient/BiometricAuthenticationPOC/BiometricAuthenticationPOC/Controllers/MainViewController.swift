//
//  MainViewController.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/25/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: Constants
    static let identifier = "\(MainViewController.self)"
    
    // MARK: Properties
    
    
    // MARK: Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        debugPrint("\(MainViewController.self) DELETED.")
    }
    
    // MARK: Actions
    @IBAction func signOutButtonClicked(_ sender: UIBarButtonItem) {
        Navigator(navigationController).navigateToLoginScreen()
    }
    // MARK: Private methods
    
    // MARK: Public methods
    
}
