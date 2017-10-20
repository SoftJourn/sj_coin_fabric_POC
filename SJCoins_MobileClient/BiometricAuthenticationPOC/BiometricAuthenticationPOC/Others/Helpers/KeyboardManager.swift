//
//  KeyboardManager.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/18/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import UIKit

class KeyboardManager: NSObject {
    
    // MARK: Properties
    private var scrollView: UIScrollView!
    private var originalInsets: UIEdgeInsets!
    private var view: UIView!
    private var tapGeture: UITapGestureRecognizer!
    
    init(_ scrollView: UIScrollView, _ view: UIView) {
        self.scrollView = scrollView
        self.originalInsets = scrollView.contentInset
        self.view = view
    }
    
    deinit {
        debugPrint("\(KeyboardManager.self) DELETED.")
    }
    
    // MARK: Private methods
    @objc private func keyboardWasShown(_ notification: Notification) {
        tapGeture.isEnabled = true
        
        var userInfo = notification.userInfo!
        var keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        
        var contentInset = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillBeHidden(_ notification: Notification) {
        tapGeture.isEnabled = false
        scrollView.contentInset = originalInsets
        scrollView.scrollIndicatorInsets = originalInsets
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: Public methods
    func configureSelf() {
        // Register For Keyboard Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: .UIKeyboardWillHide, object: nil)
        
        tapGeture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGeture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGeture)
    }
}

