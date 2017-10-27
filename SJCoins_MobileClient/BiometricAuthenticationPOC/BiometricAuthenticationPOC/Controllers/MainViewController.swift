//
//  MainViewController.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/25/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class MainViewController: UIViewController {
    
    // MARK: Constants
    static let identifier = "\(MainViewController.self)"
    
    // MARK: Properties
    @IBOutlet private weak var successLabel: UILabel!
    
    // MARK: Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         successLabel.text = Defaults[.user]
    }
    
    deinit {
        debugPrint("\(MainViewController.self) DELETED.")
    }
    
    // MARK: Actions
    @IBAction func signOutButtonClicked(_ sender: UIBarButtonItem) {
        Navigator(navigationController).navigateToLoginScreen()
        UserDefaults.standard.removeObject(forKey: Constants.key.user)
        Defaults.remove(.user)
    }
    // MARK: Private methods
    
    // MARK: Public methods
    
}
