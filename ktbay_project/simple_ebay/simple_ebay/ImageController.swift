//
//  ImageController.swift
//  simple_ebay
//
//  Created by Katie Barnwell on 1/5/17.
//  Copyright © 2017 kt. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class ImageController {
    
    // this will need to take in "urlString" - we will pass this in when we are calling it from the viewcontroller
    class func imageFromURL(urlString: String, completionHandler: (ImageSearchResult?, NSError?) -> Void) {
        let imageURL = urlString
        Alamofire.request(.GET, imageURL)
            .response { (request, response, data, error) in
                guard let imageData = data else {
                    print("guess we needed imageURLResult")
                    return
                }
                self.image = UIImage(data: imageData)
                completionHandler(imageURLResult, nil)
        }
    }

}
