//
//  ViewController.swift
//  MLearner
//
//  Created by Pavel Chechetin on 8/10/18.
//  Copyright © 2018 Pavel Chechetin. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertWith(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
//    func appDelegate() -> AppDelegate {
//        return (UIApplication.shared.delegate! as! AppDelegate)
//    }
}

