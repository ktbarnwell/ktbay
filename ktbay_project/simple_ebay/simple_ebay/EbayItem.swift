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

class EbayItem{
    var idNumber: Int?
    var itemId: Int?
    var title: String?
    var galleryURL: String?
    var location: String?
    var viewItemURL: String?
    var itemImageView: UIImageView?
    
    required init(json: JSON, id: Int?) {
        //print(json)
        // I know this is bad and definitely needs a loop - but I don't know ios well enough to write it rn so just wanna get it working!
        self.idNumber = id
        self.itemId = json["itemId"][0].intValue
        self.title = json["title"][0].stringValue
        self.galleryURL = json["galleryURL"][0].stringValue
        //print(self.galleryURL)
        self.location = json["location"][0].stringValue
        self.viewItemURL = json["viewItemURL"].stringValue
        // a little more to get the actual image from the galleryURL
        self.itemImageView = UIImageView()
//        getImagesDummy(self.galleryURL!)
//        print(self.galleryURL!)
//        if let image = self.itemImageView!.image {
//            print("Image exists")
//        }
//        else {
//            print("there is no image")
//        }
        //if let thisImageView: UIImageView? = nil {
            
          //  getImagesDummy(item.galleryURL!)        }
        //print("got dummy image")
    }
    
    
    class func getItems(searchString: String?, completionHandler: (SearchTerm?, NSError?) -> Void) {
        //let securePath = newSearchString!
        let securePath = searchString!
        print(securePath)
        Alamofire.request(.GET, securePath)
            .responseItemArray { response in
                completionHandler(response.result.value, response.result.error)
            }
    }
    
//    func dummyImage(urlString: String!) -> Void {
//        print(urlString)
//        self.itemImageView!.imageForUrl(urlString)
//    }
    
    func getImagesDummy(urlString: String!) -> Void {
        ImageLoader.sharedLoader.imageForUrl(urlString, completionHandler:{(image: UIImage?, url: String) in
            self.itemImageView!.image = image
        })
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
                
                // switch statement that checks whether result =
                switch result {
                case .Success(let value):
                    let json = SwiftyJSON.JSON(value)
                    // here is where we initialize SearchTerm
                    let search = SearchTerm()
                    var allItems = [EbayItem]()
                    //let searchResultZero = json["findItemsByKeywordsResponse"][0]["searchResult"][0]["item"]
                    let items = json["findItemsByKeywordsResponse"][0]["searchResult"][0]["item"]
                    
                    for jsonEbayItem in items
                    {
                        //print (jsonEbayItem.1)
                        let ebayItem = EbayItem(json: jsonEbayItem.1, id: Int(jsonEbayItem.0))
                        // how to write wrapper? if id+1 is less than count, wrapper = viewItemURL of next item
                        allItems.append(ebayItem)
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
