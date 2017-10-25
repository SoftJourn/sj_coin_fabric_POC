//
//  Navigator.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/17/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import UIKit

class Navigator {
    
    // MARK: Properties
    private var navController: UINavigationController?
    
    init(_ navigationController: UINavigationController?) {
        navController = navigationController
    }
    
    deinit {
        debugPrint("\(Navigator.self) DELETED.")
    }
    
    // MARK: Private methods
    private func push(_ controller: UIViewController) {
        navController?.pushViewController(controller, animated: true)
    }
    
    private func present(_ controller: UIViewController) {
        navController?.present(controller, animated: true, completion: nil)
    }
    
    private func presentAsRoot(_ controller: UIViewController) {
        UIApplication.shared.keyWindow?.rootViewController? = controller
    }
    
    // MARK: Public methods
    // PUSH
    func pushSignUpScreen() {
        let controller: SignUpViewController = UIStoryboard.storyboard(.main).instantiate()
        push(controller)
    }
    
    func pushSignInScreen() {
        let controller: SignInViewController = UIStoryboard.storyboard(.main).instantiate()
        push(controller)
    }
    
    func pushLdapSignInScreen() {
        let controller: LdapSignInViewController = UIStoryboard.storyboard(.main).instantiate()
        push(controller)
    }

    func pushFaceSignInScreen() {
        let controller: FaceSignInViewController = UIStoryboard.storyboard(.main).instantiate()
        push(controller)
    }
    
    // NAVIGATE AS ROOT
    func navigateToLoginScreen() {
        let controller = UIStoryboard.storyboard(.main).instantiateViewController(withIdentifier: "NavigationInitialViewController")
        presentAsRoot(controller)
    }

    func navigateToMainScreen() {
        let controller = UIStoryboard.storyboard(.main).instantiateViewController(withIdentifier: "NavigationMainViewController")
        presentAsRoot(controller)
    }
}
