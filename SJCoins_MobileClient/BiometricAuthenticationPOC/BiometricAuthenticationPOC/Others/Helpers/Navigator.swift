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

    
    // PRESENT
//    func presentSignUpScreen() {
//        let controller: SignUpViewController = UIStoryboard.storyboard(.main).instantiate()
//        present(controller)
//    }
//
//    func presentSignInScreen() {
//        let controller: SignInViewController = UIStoryboard.storyboard(.main).instantiate()
//        present(controller)
//    }
}
