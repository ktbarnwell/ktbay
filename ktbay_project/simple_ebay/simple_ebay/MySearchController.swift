//
//  MySearchController.swift
//  simple_ebay
//
//  Created by Katie Barnwell on 1/5/17.
//  Copyright © 2017 kt. All rights reserved.
//

import UIKit

class MySearchController: UIViewController {

    var searchString = "please God"
    
    @IBOutlet weak var testImageView: UIImageView!
    @IBOutlet weak var searchText: UITextField!
    @IBAction func searchButton(sender: AnyObject) {
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = loadImageFromPath("/Users/katie/repos/ktbay/ktbay_project/simple_ebay/temp_ktbay_logo.png")
        testImageView.image = image
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    
        let destinationVC = segue.destinationViewController as! ResultsViewController
        destinationVC.labelText = self.searchText.text
        
        // format search string to correctly attach to search URL
        if let textToChange: NSString = self.searchText.text {
            let newVar = textToChange.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            
            let stringBase = "https://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-NAME=FindingService&SERVICE-VERSION=1.0.0&GLOBAL-ID=EBAY-US&SECURITY-APPNAME=KatieBar-ktebay-PRD-f2f8dabd4-01019dd9&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&keywords="
            destinationVC.searchString = stringBase.stringByAppendingString(newVar)
            print(destinationVC.searchString)
            //destinationVC.searchTerm = newVar
        }
            
        else {
            print("went into else loop")
        }
        
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            
            print("missing image at: \(path)")
        }
        print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
        
    }

}



