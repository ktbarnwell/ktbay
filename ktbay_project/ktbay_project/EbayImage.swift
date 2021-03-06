//
//  EbayImage.swift
//  ktbay_project
//
//  Created by Katie Barnwell on 11/6/16.
//  Copyright © 2016 kt. All rights reserved.
//

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




class EbayImage: NSObject {
    var url = "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&&SERVICE-NAME=FindingService&SERVICE-VERSION=1.0.0&GLOBAL-ID=EBAY-US&SECURITY-APPNAME=KatieBar-ktebay-PRD-f2f8dabd4-01019dd9&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD"

}
