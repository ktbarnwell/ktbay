//
//  EbayItem.swift
//  simple_ebay
//
//  Created by Katie Barnwell on 1/2/17.
//  Copyright © 2017 kt. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

enum ItemFields: String {
    case ItemId = "itemId"
    case Title = "title"
    case GalleryURL = "galleryURL"
    case Location = "location"
    case ViewItemURL = "viewItemURL"
    // enum more fields later when we understand better
}

class EbayItem: NSObject {
    var itemId: Int?
    var title: String?
    var galleryURL: String?
    
    required init(json:JSON, id: Int?) {
        self.itemID = id
        self.title = json[ItemFields.Title.rawValue].stringValue
        self.galleryURL = json[ItemFields.GalleryURL.rawValue].stringValue
        self.location = json[ItemFields.Location.rawValue].stringValue
    }
    
    class func endpointForItem() -> String {
        return "https://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-NAME=FindingService&SERVICE-VERSION=1.0.0&GLOBAL-ID=EBAY-US&SECURITY-APPNAME=KatieBar-ktebay-PRD-f2f8dabd4-01019dd9&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&keywords=tark%20pants%20shimmer"
    }
    
    private class func getItemAtPath(path: String, completionHandler: (ItemWrapper?, NSError?) -> Void) {
        
        let securePath = path.stringByReplacingOccurrencesOfString("http://", withString: "https://", options: .AnchoredSearch)
        // I think this is from ebay but let's try the other -- let params = ["keywords":"tark paris capri"]
        let params = ["searchResult":"item"]
        Alamofire.request(.GET, securePath, parameters: params)
            .responseJSON { response in
                if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)
                    if let itemId = json["searchResult"]["item"][0]["itemId"].string{
                        print(itemId)
                    }
            }
        
    }


}


