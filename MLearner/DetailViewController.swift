//
//  DetailViewController.swift
//  MLearner
//
//  Created by Pavel Chechetin on 8/7/18.
//  Copyright © 2018 Pavel Chechetin. All rights reserved.
//

import Foundation
import UIKit

import os.log

class DetailViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!

    func showImageFor(indexPath: IndexPath) {
        let targetIndex = indexPath[1]
        let targetItem = (UIApplication.shared.delegate! as! AppDelegate).googleCustomSearchService.response!.items[targetIndex]
            
        if let url = targetItem.link.url {
            let urlSession          = URLSession.shared
            let activityIndicator   = UIActivityIndicatorView(style: .gray)

            image.addSubview(activityIndicator)
            activityIndicator.frame = image.bounds
            activityIndicator.startAnimating()

            let dataTask = urlSession.dataTask(with: url) { data, response, error in
                guard error != nil else {
                    DispatchQueue.main.async {
                        self.showAlertWith(title: "OOps", message: "Having hard time to load URL from ther iternet. Details: \(error!)")
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    DispatchQueue.main.async {
                        let statusCode = (response! as! HTTPURLResponse).statusCode
                        
                        self.showAlertWith(title: "OOps", message: "Error HTTP response from: \(url). Status code: \(statusCode)")
                    }
                    return
                }
                
                let image = UIImage(data: data!)

                DispatchQueue.main.async {
                    activityIndicator.removeFromSuperview()
                    
                    self.image.image = image
                }
            }
            
            dataTask.resume()

        } else {
            showAlertWith(title: "OOps", message: "Having hard time to load image for \(targetItem.title)")
        }
    }
}
