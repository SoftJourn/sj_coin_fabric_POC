//
//  FaceSignInViewController.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/25/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import UIKit
import PKHUD
import SwiftyUserDefaults

class FaceSignInViewController: UIViewController {
    
    // MARK: Constants
    static let identifier = "\(FaceSignInViewController.self)"
    
    
    // MARK: Properties
    @IBOutlet weak var dropDown: UIPickerView!
    @IBOutlet weak var emailTextField: UITextField!

    var emailList = [RegisterResponseBody]()
    var chosenUser: RegisterResponseBody?
    private var cameraService: CameraManager!

    
    // MARK: Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraService = CameraManager(delegate: self)
        emailTextField.delegate = self
        
        if let data = UserDefaults.standard.value(forKey: Constants.key.models) as? Data, let users = try? PropertyListDecoder().decode(Array<RegisterResponseBody>.self, from: data) {
            debugPrint(users)
            emailList = users
        }
    }
    
    deinit {
        debugPrint("\(FaceSignInViewController.self) DELETED.")
    }
    
    // MARK: Actions
    @IBAction func signInWithFaceButtonClicked(_ sender: UIButton) {
        chosenUser != nil ? authorization() : showError()
    }
    
    // MARK: Private methods
    private func authorization() {
        cameraService.takePhoto { [unowned self] image in
            HUD.show(.label("Signing in ..."))
            AuthorizationManager.loginRequest(ldap: nil, password: nil, email: self.chosenUser!.email, face: image) { result in
                DispatchQueue.main.async {
                    HUD.hide()
                    self.handleAuthorization(result: result)
                }
            }
        }
    }
    
    private func showError() {
        HUD.flash(.labeledError(title: "", subtitle: "Please chose user email."), delay: Constants.delay.failed)
    }
    
    private func handleAuthorization(result: Result<Any>) {
        switch result {
        case .success(let model):
            // Save model in UserDefaults
            let user = model as! LoginResponseBody
            let string = "\(user.firstName) \(user.lastName) signed in successfully with confidence: \(user.verifyResponse.confidence)."
            Defaults[.user] = string
            
            // Navigate as root to another view controller
            Navigator(navigationController).navigateToMainScreen()
        case .failure(let error):
            HUD.flash(.labeledError(title: "", subtitle: error.localizedDescription), delay: Constants.delay.failed)
            debugPrint(error)
        }
    }
    // MARK: Public methods
    
}

extension FaceSignInViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return emailList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = emailList[row].email
        pickerLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.thin)
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        emailTextField.text = emailList[row].email
        chosenUser = emailList[row]
        dropDown.isHidden = true
    }
}

extension FaceSignInViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            if emailList.count > 0 {
                dropDown.isHidden = false
            } else {
                HUD.flash(.labeledError(title: "", subtitle: "There are no registred users."), delay: Constants.delay.failed)
            }
            emailTextField.endEditing(true)
        }
    }
}

extension FaceSignInViewController: CameraManagerDelegate {
    
    func cameraManager(present picker: UIImagePickerController) {
        present(picker, animated: true, completion: nil)
    }
}
