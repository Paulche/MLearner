//
//  SearchUIController.swift
//  MLearner
//
//  Created by Pavel Chechetin on 8/7/18.
//  Copyright © 2018 Pavel Chechetin. All rights reserved.
//

import Foundation
import UIKit
import os.log

class SearchUIController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var searchTermTextField: UITextField!
    @IBOutlet weak var searchStartButton: UIButton!
    
    // MARK: - UI Responder
    @IBAction func searchStartButtonAction(_ sender: Any) {
        if searchTermTextField.text! != "" {
            let activityIndicator = UIActivityIndicatorView(style: .gray)
            
            // Add and Start spinner
            searchTermTextField.addSubview(activityIndicator)
            activityIndicator.frame = searchTermTextField.bounds
            activityIndicator.startAnimating()
            
            AppDelegate().googleCustomSearchService.search(term: searchTermTextField.text!) { error in
                if let error = error {
                    self.showAlertWith(title: "OOps", message: "Error during loading: \(error.localizedDescription)")
                }
                
                DispatchQueue.main.async {
                    activityIndicator.removeFromSuperview()
                    
                    // In order to distinguish an internal call from the one called by UITextField
                    if (sender is SearchUIController) {
                        self.searchTermTextField.resignFirstResponder()
                    } else {
                        // Trigger the segue manually
                        self.performSegue(withIdentifier: "searchStart", sender: nil)
                    }
                }
            }
            
        } else {
            showAlertWith(title: "OOps", message: "Empty search term")
        }
    }
    
    // MARK: - Seque Management
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }

    // MARK: - Keyboard Responder
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchStartButtonAction(self)
        
        return false
    }
}
