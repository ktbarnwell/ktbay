//
//  EbayItem.swift
//  ktbay_project
//
//  Created by Katie Barnwell on 11/5/16.
//  Copyright © 2016 kt. All rights reserved.
// let itemId = json["searchResult"][

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

/* API response to a tark shimmer search looks like this:
request URL: http://www.ebay.com/sch/i.html?_nkw=tark+shimmer&_ddo=1&_ipg=100&_pgn=1

1st layer: searchResult I think is same as 'results'
2nd layer: item
3rd layer: itemId, location, galleryURL, condition
4th layer: conditionId

{
"itemSearchURL": "http://www.ebay.com/sch/i.html?_nkw=tark+shimmer&_ddo=1&_ipg=100&_pgn=1",
"paginationOutput": {
    "totalPages": "1",
    "entriesPerPage": "100",
    "pageNumber": "1",
    "totalEntries": "1"
    },
"ack": "Success",
"timestamp": "2016-11-05T22:51:30.187Z",
"searchResult": {
    "item": [
        {
        "itemId": "262676729558",
        "topRatedListing": "false",
        "globalId": "EBAY-US",
        "title": "EUC TARK'1 PARIS WOMEN'S PANTS SZ.T1 WITH SHIMMER SNAKESKIN PRINT MADE IN FRANCE",
        "country": "US",
        "primaryCategory": 
            {
            "categoryId": "63863",
            "categoryName": "Pants"
            },
        "autoPay": "false",
        "galleryURL": "http://thumbs3.ebaystatic.com/m/mVZe4L23-hIrx6-epY82XXA/140.jpg",
        "shippingInfo": {
            "expeditedShipping": "true",
            "shippingType": "Calculated",
            "handlingTime": "2",
            "oneDayShippingAvailable": "false",
            "shipToLocations": ["US", "CA", "GB", "AU", "AT", "BE", "FR", "DE", "IT", "JP", "ES", "TW", "NL", "CN", "HK", "DK", "RO", "SK", "BG", "CZ", "FI", "HU", "LV", "LT", "MT", "EE", "GR", "PT", "CY", "SI", "SE", "KR", "ID", "TH", "IE", "PL", "RU", "IL", "NZ", "PH"]
        },
        "location": "Trenton,NJ,USA",
        "postalCode": "08610",
        "returnsAccepted": "false",
        "viewItemURL": "http://www.ebay.com/itm/EUC-TARK1-PARIS-WOMENS-PANTS-SZ-T1-SHIMMER-SNAKESKIN-PRINT-MADE-FRANCE-/262676729558",
        "sellingStatus": {
            "currentPrice": {
            "_currencyId": "USD",
            "value": "19.95"
            },
            "timeLeft": "P9DT5H19M36S",
            "convertedCurrentPrice": {
                "_currencyId": "USD",
                "value": "19.95"
            },
            "sellingState": "Active"
        },
        "paymentMethod": "PayPal",
        "isMultiVariationListing": "false",
        "condition": {
            "conditionId": "3000",
            "conditionDisplayName": "Pre-owned"
        },
        "listingInfo": {
            "listingType": "FixedPrice",
            "gift": "false",
            "bestOfferEnabled": "true",
            "startTime": "2016-10-16T04:11:06.000Z",
            "buyItNowAvailable": "false",
            "endTime": "2016-11-15T04:11:06.000Z"
        }
    }],
    "_count": "1"
},
"version": "1.13.0"
}
*/


// for us, specieswrapper = first layer - itemSearchURL,searchResult, paginationOutput
// ["searchResult"]["item"][0]["itemId"] is the value of the itemId of the first thing


//enum ItemFields: String {
//    case ItemId = "itemId"
//    case Title = "title"
//    case GalleryURL = "galleryURL"
//    case Location = "location"
//    case ViewItemURL = "viewItemURL"
//    // enum more fields later when we understand better
//}

class ItemWrapper {
    var itemSearchURL: String?
    //var searchResult: [String]?
    var items: [EbayItem]?
    var count: Int?
    // var next:
    // wait on this because it's a nested json -- var paginationOutput: Int?
    
    // var next: String? -- we can figure out later
    // var previous: String? -- we can figure out later
    
}

// species 'id' comes from the last digit of the "url" at the bottom;
// remember that http://www.ebay.com/itm/[itemId] takes you to link
class EbayItem {
    var idNumber: Int?
    var itemId: Int?
    var title: String?
    var galleryURL: String?
    var location: String?
    var viewItemURL: String?
    
    required init(json: JSON, id: Int?) {
        print(json)
        // I know this is bad and definitely needs a loop - but I don't know ios well enough to write it rn so just wanna get it working!
        self.idNumber = id
        self.itemId = json["itemId"][0].intValue
        self.title = json["title"][0].stringValue
        self.galleryURL = json["galleryURL"][0].stringValue
        self.location = json["location"][0].stringValue
        self.viewItemURL = json["viewItemURL"].stringValue
        
        ///
    }
    
    class func endpointForItem() -> String {
        return "https://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-NAME=FindingService&SERVICE-VERSION=1.0.0&GLOBAL-ID=EBAY-US&SECURITY-APPNAME=KatieBar-ktebay-PRD-f2f8dabd4-01019dd9&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&keywords=tark%20pants%20shimmer"
    }
    
    
    private class func getItemAtPath(path: String, completionHandler: (ItemWrapper?, NSError?) -> Void) {
    
        let securePath = path.stringByReplacingOccurrencesOfString("http://", withString: "https://", options: .AnchoredSearch)
        // I think this is from ebay but let's try the other -- let params = ["keywords":"tark paris capri"]
        //let params = ["searchResult":"item"]
        Alamofire.request(.GET, securePath)
            //, parameters: params)
            .responseItemArray { response in
                completionHandler(response.result.value, response.result.error)
        }
        
    }

    
    class func getItem(completionHandler: (ItemWrapper?, NSError?) -> Void) {
        getItemAtPath(EbayItem.endpointForItem(), completionHandler: completionHandler)
    }
    
//    class func getMoreItems(wrapper: ItemWrapper?, completionHandler: (ItemWrapper?, NSError?) -> Void) {
//        guard let nextPath = wrapper?.next else {
//            completionHandler(nil, nil)
//            return
//        }
//        getItemAtPath(nextPath, completionHandler: completionHandler)
//    }
}
    



extension Alamofire.Request {
    func responseItemArray(completionHandler: Response<ItemWrapper, NSError> -> Void) -> Self {
            
        let responseSerializer = ResponseSerializer<ItemWrapper, NSError> {request, response, data, error in
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
                let wrapper = ItemWrapper()
                wrapper.count = json["findItemsByKeywordsResponse"][0]["searchResult"][0]["@count"].intValue
                //print(wrapper.count)
                wrapper.itemSearchURL = json["findItemsByKeywordsResponse"][0]["itemSearchURL"].stringValue
                //if let wrapper.next = json["findItemsByKeywordsResponse"][0]["searchResult"][0]["@count"]
                    /*wrapper.next = json["next"].stringValue
                    wrapper.previous = json["previous"].stringValue
                    wrapper.count = json["count"].intValue*/
               
                var allItems = [EbayItem]()
                //print(json)
       
                let searchResultZero = json["findItemsByKeywordsResponse"][0]["searchResult"][0]["item"]
                let items = json["findItemsByKeywordsResponse"][0]["searchResult"][0]["item"]
                
                
                //print("printing itemId")
                //print(itemId)
                for jsonEbayItem in items
                {
                    //print (jsonEbayItem.1)
                    let ebayItems = EbayItem(json: jsonEbayItem.1, id: Int(jsonEbayItem.0))
                    // how to write wrapper? if id+1 is less than count, wrapper = viewItemURL of next item
                    allItems.append(ebayItems)
                }
                wrapper.items = allItems
                return .Success(wrapper)
            case .Failure(let error):
                return .Failure(error)
            }
        }
            
    return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}