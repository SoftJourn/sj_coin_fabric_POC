//
//  CameraManagerDelegate.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/26/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import UIKit

// Protocol that returns back to UIViewController interaction from helper object.
protocol CameraManagerDelegate: class {
    func cameraManager(present picker: UIImagePickerController)
}

extension CameraManagerDelegate {
    
}
