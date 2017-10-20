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
    typealias ImageResult = (UIImage) -> ()
    
    // MARK: Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ldapErrorLabel: UILabel!
    @IBOutlet weak var ldapTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!

    var login: validationStatus { return Validator.validate(ldapString) }
    var password: validationStatus { return Validator.validate(passString) }

    private var scrollService: KeyboardManager!
    private var ldapString: String { return ldapTextField.text! }
    private var passString: String { return passwordTextField.text! }
    private var imageResult: ImageResult?
    private let picker = UIImagePickerController()
    
    
    // MARK: Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ldapTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .done
        scrollService = KeyboardManager(scrollView, view)
        scrollService.configureSelf()
        picker.delegate = self
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
    
    func takePhoto(result: @escaping ImageResult) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imageResult = result
            picker.allowsEditing = false
            picker.sourceType = .camera
            picker.cameraDevice = .front
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
        }
    }
    
    // MARK: Public methods
    func authorization() {
    
    }
    
    func showError() {
        handleValidation(status: login, viaLabel: ldapErrorLabel)
        handleValidation(status: password, viaLabel: passwordErrorLabel)
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

extension BaseSignViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var capturedImage = UIImage()
        capturedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageResult?(capturedImage)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

