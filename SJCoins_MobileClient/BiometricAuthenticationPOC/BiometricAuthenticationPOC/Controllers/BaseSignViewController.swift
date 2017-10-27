//
//  BaseSignViewController.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/18/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import UIKit

class BaseSignViewController: UIViewController {
    
    // MARK: Constants
    
    // MARK: Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ldapErrorLabel: UILabel!
    @IBOutlet weak var ldapTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var ldapString: String { return ldapTextField.text! }
    var passString: String { return passwordTextField.text! }
    var login: validationStatus { return Validator.validate(ldapString) }
    var password: validationStatus { return Validator.validate(passString) }

    private var scrollService: KeyboardManager!
    
    // MARK: Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ldapTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .done
        scrollService = KeyboardManager(scrollView, view)
        scrollService.configureSelf()
    }
    
    deinit {
        debugPrint("\(BaseSignViewController.self) DELETED.")
    }
    
    // MARK: Actions
    @IBAction func ldapDidChange(_ sender: UITextField) {
        handleValidation(status: login, viaLabel: ldapErrorLabel)
    }
    
    @IBAction func passwordDidChange(_ sender: UITextField) {
        handleValidation(status: password, viaLabel: passwordErrorLabel)
    }
    
    // MARK: Private methods
    private func handleValidation(status: validationStatus, viaLabel label: UILabel) {
        func config(_ label: UILabel, text: String, isHidden: Bool) {
            label.text = text
            label.isHidden = isHidden
        }
        switch status {
        case .success:
            config(label, text: "", isHidden: true)
        case .failure:
            config(label, text: "This field is reqiured.", isHidden: false)
        }        
    }
    
    // MARK: Public methods
    func authorization() {
    
    }
    
    func showError() {
        handleValidation(status: login, viaLabel: ldapErrorLabel)
        handleValidation(status: password, viaLabel: passwordErrorLabel)
    }
    
    func emailTextFieldDidBeginEditing() {
        
    }
}

extension BaseSignViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string == " " ? false : true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == ldapTextField {
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}
