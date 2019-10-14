//
//  CustomImageView.swift
//  InstagramClone
//
//  Created by Martin Nasierowski on 12/10/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()


class CustomImageView: UIImageView {
    
    var lastImageUrlUsedToLoadImage: String?
    
    func loadImage(with urlString: String) {
        
        self.image = nil
        
        lastImageUrlUsedToLoadImage = urlString
        
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
                
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to load image with error: ", error.localizedDescription)
                return
            }
            
            if self.lastImageUrlUsedToLoadImage != url.absoluteString {
                return
            }
            
            guard let imageData = data else { return }
            
            let avatar = UIImage(data: imageData)
            
            imageCache[url.absoluteString] = avatar
            
            DispatchQueue.main.async {
                self.image = avatar
            }
        }.resume()
    }
}
