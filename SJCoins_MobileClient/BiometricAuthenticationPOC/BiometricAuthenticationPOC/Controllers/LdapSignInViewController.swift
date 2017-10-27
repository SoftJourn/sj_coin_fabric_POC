//
//  LdapSignInViewController.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/18/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import UIKit
import PKHUD
import SwiftyUserDefaults

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
            let user = model as! LoginResponseBody
            let string = "\(user.firstName) \(user.lastName) signed in successfully."
            Defaults[.user] = string
            
            let model = RegisterResponseBody(email: user.email, firstName: user.firstName, lastName: user.lastName, personId: user.personId)
            var existingModels = [RegisterResponseBody]()
            // Take existing models from UserDefaults
            if let data = UserDefaults.standard.value(forKey: Constants.key.models) as? Data, let users = try? PropertyListDecoder().decode(Array<RegisterResponseBody>.self, from: data) {
                existingModels = users
            }
            if existingModels.count > 0 {
                for user in existingModels {
                    if user.email != model.email {
                        existingModels.append(model)
                    }
                }
            } else {
                existingModels.append(model)
            }
            debugPrint(existingModels)
            // Save models in UserDefaults
            UserDefaults.standard.set(try? PropertyListEncoder().encode(existingModels), forKey: Constants.key.models)

            Navigator(navigationController).navigateToMainScreen()
        case .failure(let error):
            HUD.flash(.labeledError(title: "", subtitle: error.localizedDescription), delay: Constants.delay.failed)
            debugPrint(error)
        }
    }
    
    // MARK: Public methods
    override func authorization() {
        HUD.show(.label("Signing in ..."))
        AuthorizationManager.loginRequest(ldap: ldapString, password: passString, email: "", face: nil) { result in
            DispatchQueue.main.async {
                HUD.hide()
                self.handleAuthorization(result: result)
            }
        }
    }
}
