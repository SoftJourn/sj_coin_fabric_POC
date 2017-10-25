//
//  SignUpViewController.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/17/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import UIKit
import PKHUD
import SwiftyUserDefaults

class SignUpViewController: BaseSignViewController {
    
    // MARK: Constants
    static let identifier = "\(SignUpViewController.self)"
    
    // MARK: Properties
    @IBOutlet private weak var attachFaceButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    
    private var face: UIImage?
    
    // MARK: Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
    }
    
    deinit {
        debugPrint("\(SignUpViewController.self) DELETED.")
    }
    
    // MARK: Actions
    @IBAction func attachFaceButtonClicked(_ sender: UIButton) {
        takePhoto { [unowned self] image in
            self.face = image
            self.attachFaceButton.setTitle("FACE ATTACHED", for: .normal)
            //HUD.flash(.success, delay: 1.0)
            debugPrint(image)
        }
    }
    
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        login == .success && password == .success && face != nil ? authorization() : showError()
    }
    
    // MARK: Private methods
    private func configureButtons() {
        attachFaceButton.layer.borderWidth = 1
        attachFaceButton.layer.borderColor = UIColor(red: CGFloat(49)/255, green: CGFloat(170)/255, blue: CGFloat(255)/255, alpha: 1.0).cgColor
    }
    
    private func handleAuthorization(result: Result<Any>) {
        switch result {
        case .success(let model):
            // Save model in UserDefaults
            var models = [RegisterResponseBody]()
            models.append(model as! RegisterResponseBody)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(models), forKey:"models")

            HUD.flash(.success, delay: Constants.delay.success) { [unowned self] _ in
                self.navigationController?.popViewController(animated: true)
            }
        case .failure(let error):
            HUD.flash(.labeledError(title: "", subtitle: error.localizedDescription), delay: Constants.delay.failed)
            debugPrint(error)
        }
    }
    
    // MARK: Public methods
    override func authorization() {
        HUD.show(.label("Registering ..."))
        AuthorizationManager.registerRequest(ldap: ldapString, password: passString, face: face!) { result in
            DispatchQueue.main.async {
                HUD.hide()
                self.handleAuthorization(result: result)
            }
        }
    }
    
    override func showError() {
        super.showError()
        guard login == .success && password == .success && face == nil else { return }
        HUD.flash(.label("Face not attached."), delay: 1.0)
    }
}
