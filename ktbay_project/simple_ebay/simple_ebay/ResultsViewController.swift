//
//  ResultsViewController.swift
//  simple_ebay
//
//  Created by Katie Barnwell on 11/8/16.
//  Copyright © 2016 kt. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class ResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var headLabel: UILabel!
    
    let cellIdentifier = "CustomTableViewCell"
    var items:Array<EbayItem>?
    var searchTerm:SearchTerm?
    // rename later
    // when we have searchString as set to something here via the code, it DOES show up. ok!
    //var searchString = "test string"
    
    var searchString:String?
    var labelText:String?
    var dummyImageView:UIImageView?
    //var imageDict = [Int:UIImageView]()
    
    
       // don't forget that we changed UITableView from an optional to an exlamation just now
    
    
    required init?(coder decoder: NSCoder) {
        print("we hit coder decoder init")
        //self.labelText = ""
        self.dummyImageView = UIImageView()
        super.init(coder: decoder)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getImagesDummy()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView?.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
        self.loadItems()
        // loadItems calls ebayItem.getItems
        dispatch_async(dispatch_get_main_queue()) {
            if let myLabel = self.labelText {
                self.headLabel.text = myLabel
                self.reloadInputViews()
                
            }
            else {
                print("viewDidLoad didn't work")
            }
        }
        self.tableView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadItems() {
        EbayItem.getItems(self.searchString) {search, error in
            guard error == nil else {
                let alert = UIAlertController(title: "Error",
                    message: "Could not load first item \(error?.localizedDescription)",
                    preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            self.getArray(search)
            //self.getImages()
            //self.unWrapImages()
            self.tableView?.reloadData()
        }
    }
            
    // call this with
    func getArray(search: SearchTerm?) {
        self.searchTerm = search
        if self.items == nil {
            print("entered getArray loop")
            self.items = self.searchTerm!.items
            self.tableView?.reloadData()
        }
        else {
            print("this is fucking hopeless")
        }
    }
    
    func getImagesDummy() -> Void {
        self.dummyImageView!.imageFromUrl("http://thumbs2.ebaystatic.com/m/mcxudqufgkPZPK5gdUbO7qg/140.jpg")
    }
//    
//    func getImages() -> Void {
//        for item in self.items! {
//            if let thisString = item.galleryURL {
//                //print(item.itemId)
//                let myImage: UIImageView! = nil
//                if let thisImage = myImage {
//                    thisImage.imageFromUrl(thisString)
//                    imageDict[item.itemId!] = thisImage
//        }
//        
//    }
//        }
//    }
    
//    func getImagesTwo() -> Void {
//        for item in self.items! {
//            if let thisItem = self.itemImageView {
//                print(self.itemImage
//            }
//            }
//            
//        }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if self.items == nil {
//            return 0
//        }
//        return self.items!.count
        guard let items = self.items else {
            print("still no items")
            return 0
        }
        return items.count

    }
    
  
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        let cell:CustomTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CustomTableViewCell

        if self.items != nil {
            let item = self.items![indexPath.row]
            cell.myTitle?.text = item.title
            cell.myTitle?.adjustsFontSizeToFitWidth = true
            //print(self.imageDict[item.itemId!])
            if let thisImageView = item.itemImageView {
                cell.myImageView?.image = thisImageView.image
                
                print("image wasn't null")
            }
            //cell.myImageView?.image = self.dummyImageView?.image
        }
        cell.setNeedsLayout()
        return cell
    }




    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
}

extension UIImageView {
    public func imageFromUrl(urlString: String) {
            if let url = NSURL(string: urlString) {
                let request = NSURLRequest(URL: url)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                    (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                    if let imageData = data as NSData? {
                        self.image = UIImage(data: imageData)
                    }
                }
            }
        }
}
