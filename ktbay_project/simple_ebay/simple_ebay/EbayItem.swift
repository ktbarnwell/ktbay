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

class SearchTerm {
    // probably will want to pass in params later so it would take searchString: String?
    var myString: String?
    var items: Array<EbayItem>?
//    if searchString != nil {
//        self.myString = searchString
//    }
//        
//    else {
    init(){
        self.myString = "https://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-NAME=FindingService&SERVICE-VERSION=1.0.0&GLOBAL-ID=EBAY-US&SECURITY-APPNAME=KatieBar-ktebay-PRD-f2f8dabd4-01019dd9&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&keywords=tark%20pants%20abstract"
    }
}

//class ImageSearchResult {
//    let imageURL:String?
//    var image:UIImage?
//    
//    required init(anImageURL: String?) {
//        imageURL = anImageURL
//    }
//}

class EbayItem{
    var idNumber: Int?
    var itemId: Int?
    var title: String?
    var galleryURL: String?
    var location: String?
    var viewItemURL: String?
    var image:UIImage?
    
    required init(json: JSON, id: Int?) {
        //print(json)
        // I know this is bad and definitely needs a loop - but I don't know ios well enough to write it rn so just wanna get it working!
        self.idNumber = id
        self.itemId = json["itemId"][0].intValue
        self.title = json["title"][0].stringValue
        self.galleryURL = json["galleryURL"][0].stringValue
        self.location = json["location"][0].stringValue
        self.viewItemURL = json["viewItemURL"].stringValue

    }
    
    
    class func getItems(completionHandler: (SearchTerm?, NSError?) -> Void) {
        let securePath = "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-NAME=FindingService&SERVICE-VERSION=1.0.0&GLOBAL-ID=EBAY-US&SECURITY-APPNAME=KatieBar-ktebay-PRD-f2f8dabd4-01019dd9&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&keywords=print%20pants%20vintage"
//        let securePath = searchTerm.myString.stringByReplacingOccurrencesOfString("http://", withString: "https://", options: .AnchoredSearch)
        Alamofire.request(.GET, securePath)
            .responseItemArray { response in
                completionHandler(response.result.value, response.result.error)
            }
    }
    
    class func imageFromURL() -> Void {
        let imageURL = self.galleryURL
        Alamofire.request(.GET, imageURL)
            .response { (request, response, data, error) in
                guard let imageData = data else {
                    print("guess we needed imageURLResult")
                    return
                }
                self.image = UIImage(data: imageData)
        }
    }

    
    
    
}

extension Alamofire.Request {
        func responseItemArray(completionHandler: Response<SearchTerm, NSError> -> Void) -> Self {
            
            let responseSerializer = ResponseSerializer<SearchTerm, NSError> {request, response, data, error in
                guard error == nil else {
                    return .Failure(error!)
                }
                guard let responseData = data else {
                    let failureReason = "Array could not be serialized because input data was nil."
                    let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                    return .Failure(error)
                }
                
                let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
                let result = JSONResponseSerializer.serializeResponse(request, response, responseData, error)
                
                switch result {
                case .Success(let value):
                    let json = SwiftyJSON.JSON(value)
                    let search = SearchTerm()
                    var allItems = [EbayItem]()
                    let searchResultZero = json["findItemsByKeywordsResponse"][0]["searchResult"][0]["item"]
                    let items = json["findItemsByKeywordsResponse"][0]["searchResult"][0]["item"]
                    
                    for jsonEbayItem in items
                    {
                        //print (jsonEbayItem.1)
                        let ebayItems = EbayItem(json: jsonEbayItem.1, id: Int(jsonEbayItem.0))
                        // how to write wrapper? if id+1 is less than count, wrapper = viewItemURL of next item
                        allItems.append(ebayItems)
                    }
                    search.items = allItems
                    print("I think success!")
                    return .Success(search)
                case .Failure(let error):
                    return .Failure(error)
                }
            }
            
            return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    


}
