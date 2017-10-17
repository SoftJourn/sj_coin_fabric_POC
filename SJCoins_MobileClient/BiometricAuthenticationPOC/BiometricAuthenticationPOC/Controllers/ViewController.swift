//
//  ViewController.swift
//  BiometricAuthenticationPOC
//
//  Created by Oleg Pankiv on 10/13/17.
//  Copyright © 2017 SoftJourn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
                        let json = """
                        {
                          "firstName": "Oleg",
                          "lastName": "0",
                          "email": "Jan.Monroe@gmail.com"
                        }
 """.data(using: .utf8)!
        debugPrint("Data file \(json)")
        
        // Create Struct from Data
        let person = try! Register.decode(data: json)
        print(person)
        
        let jsonPerson = try! person.encode()
        print(jsonPerson)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    
//    func function(items: [Int]) {
//        guard !items.isEmpty else { return }
//        for item in items {
//            // do something
//        }
//    }
    
//    imageView.isHidden = items.isEmpty
    
    
    
    
}

