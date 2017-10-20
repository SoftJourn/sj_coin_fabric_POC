//
//  SignUpViewController.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/17/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import UIKit
import PKHUD

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
            HUD.flash(.success, delay: 1.0)
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
    
    // MARK: Public methods
    override func authorization() {
        HUD.show(.label("Registering ..."))
        AuthorizationManager.registerRequest()
        
//        AuthorizationManager.authRequest(login: login, password: password) { [unowned self] error in
//            error != nil ? self.authFailed() : self.authSuccess()
//        }
        
    }
    
    override func showError() {
        super.showError()
        guard login == .success && password == .success && face == nil else { return }
        HUD.flash(.label("Face not attached."), delay: 1.0)
    }
}
