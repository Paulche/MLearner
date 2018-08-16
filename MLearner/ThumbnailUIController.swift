//
//  ThumbnailUIController.swift
//  MLearner
//
//  Created by Pavel Chechetin on 8/7/18.
//  Copyright © 2018 Pavel Chechetin. All rights reserved.
//

import Foundation
import UIKit
import os.log

class ThumbnailUIController: UICollectionViewController {
    fileprivate let reuseIdentifier = "ImageCell"
    fileprivate let sectionInsets   = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    fileprivate var selected: IndexPath?


    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected = indexPath
    }
    
    // MARK: - UICOllectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (UIApplication.shared.delegate! as! AppDelegate).googleCustomSearchService.response!.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell    = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageViewCell
        let index   = indexPath[1]
        
        let searchItem = (UIApplication.shared.delegate! as! AppDelegate).googleCustomSearchService.response!.items[index]
        
        let task = URLSession.shared.dataTask(with: searchItem.image.thumbnailLink.url!) { data, response, error in
            let image = UIImage(data: data!)
            
            DispatchQueue.main.async {
                cell.image!.image = image
            }
        }
        
        task.resume()

        // Configure cell
        // cell.backgroundColor = UIColor.gray

        return cell
    }

    // MARK: - Segue Management
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! DetailViewController).showImageFor(indexPath: selected!)
    }
}
