//
//  Extensions.swift
//  GoogleDrive
//
//  Created by Ankit on 20/04/19.
//  Copyright © 2019 Ankit. All rights reserved.
//

import Foundation


extension Collection {
    /**
     This method is used to get element from array. Return nill in case of array out of bounds exception.
     
     - Parameter  index:  Index of the element needs to be fetched from collection.
     - Returns:  The element at given index. If index is invalid returns nil.
     */
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    /**
     This method is used to load images from cache.
     
     - Parameter  link:  link url of the image.
     - Returns:  No value.
     */
    func loadImageUsingCache(_ link : String) {
        let url = URL(string: link)
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: link as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: link as NSString)
                    self.image = image
                }
            }
            
        }).resume()
    }
}
