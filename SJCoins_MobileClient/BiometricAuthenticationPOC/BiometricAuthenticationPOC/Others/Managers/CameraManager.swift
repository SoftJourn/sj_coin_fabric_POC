//
//  CameraManager.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/26/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import UIKit

class CameraManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Constants
    typealias ImageResult = (UIImage) -> ()

    // MARK: Properties
    private var delegate: CameraManagerDelegate!
    private var imageResult: ImageResult?
    private let picker = UIImagePickerController()
    
    init(delegate: CameraManagerDelegate) {
        super.init()
        self.delegate = delegate
        picker.delegate = self
    }

    deinit {
        debugPrint("\(CameraManager.self) DELETED.")
    }

    // MARK: Private methods

    // MARK: Public methods
    func configureSelf() {
        
    }
    
    func takePhoto(result: @escaping ImageResult) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imageResult = result
            picker.allowsEditing = false
            picker.sourceType = .camera
            picker.cameraDevice = .front
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            delegate.cameraManager(present: picker)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var capturedImage = UIImage()
        capturedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageResult?(capturedImage)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
