//
//  LdapSignInViewController.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/18/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import UIKit
import PKHUD

class LdapSignInViewController: BaseSignViewController {
    
    // MARK: Constants
    static let identifier = "\(LdapSignInViewController.self)"
    
    // MARK: Properties
    
    
    // MARK: Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        debugPrint("\(LdapSignInViewController.self) DELETED.")
    }
    
    // MARK: Actions
    @IBAction func signInButtonClicked(_ sender: UIButton) {
        login == .success && password == .success ? authorization() : showError()
    }
    
    // MARK: Private methods
    private func handleAuthorization(result: Result<Any>) {
        switch result {
        case .success(let model):
            // Save model in UserDefaults
            
            
            
            HUD.flash(.success, delay: Constants.delay.success) { [unowned self] _ in
                // Navigate as root to another view controller
                Navigator(self.navigationController).navigateToMainScreen()
            }
        case .failure(let error):
            HUD.flash(.labeledError(title: "", subtitle: error.localizedDescription), delay: Constants.delay.failed)
            debugPrint(error)
        }
    }
    
    // MARK: Public methods
    override func authorization() {
        HUD.show(.label("Login ..."))
        
        // Take registred email
        
        AuthorizationManager.loginRequest(ldap: ldapString, password: passString, email: "", face: nil) { result in
            DispatchQueue.main.async {
                HUD.hide()
                self.handleAuthorization(result: result)
            }
        }
    }
}
