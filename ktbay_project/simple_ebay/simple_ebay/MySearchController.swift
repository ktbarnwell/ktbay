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
        // tamar says: this is bad. what we want is not to use the storyboard, but to instantiate our ViewController with the params that we'll want
        // to have. 
        //let myVC = storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        //myVC.stringPassed = searchLabel.text!
        //navigationController?.pushViewController(myVC, animated: true)
        
        // for now let's just have a dummy string as the label, get it to show, and then we can hook it up later
        
        //let myVC = ResultsViewController(stringForSearch: self.searchString)
        //print("printing searchString from SearchController instantiation")
        //print(myVC.searchString!)
        
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = loadImageFromPath("/Users/katie/repos/ktbay/ktbay_project/simple_ebay/temp_ktbay_logo.png")
        testImageView.image = image
        
        //testImageView.imageForURL("http://thumbs2.ebaystatic.com/m/mBchjbZ1pJOFXLVwKJVWKTw/140.jpg")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    
        let destinationVC = segue.destinationViewController as! ResultsViewController
        
       // set labeltext (without new formatting)
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

//extension UIImageView {
//    public func imageFromUrl(urlString: String) {
//        if let url = NSURL(string: urlString) {
//            let request = NSURLRequest(URL: url)
//            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
//                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
//                if let imageData = data as NSData? {
//                    self.image = UIImage(data: imageData)
//                }
//            }
//        }
//    }
//}






