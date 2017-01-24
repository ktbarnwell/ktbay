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
    
    let cellIdentifier = "EbayTableViewCell"
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
       
        self.tableView?.rowHeight = 140
        self.tableView?.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
        self.loadItems()
        //self.getImagesDummy()
        dispatch_async(dispatch_get_main_queue()) {
            if let myLabel = self.labelText {
                self.headLabel.text = myLabel
                self.reloadInputViews()
                self.tableView?.reloadData()
            }
            else {
                print("viewDidLoad didn't work")
            }
        }
        
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
    
    func getImages() -> Void {
        if self.items != nil {
        for item in self.items! {
            if let urlString = item.galleryURL {
                ImageLoader.sharedLoader.imageForUrl(urlString, completionHandler:{(image: UIImage?, url: String) in
                    item.itemImageView!.image = image
                })
            }
        }
        }
    }
    
    
    func getImagesDummy() -> Void {
        ImageLoader.sharedLoader.imageForUrl("http://thumbs2.ebaystatic.com/m/mcxudqufgkPZPK5gdUbO7qg/140.jpg", completionHandler:{(image: UIImage?, url: String) in
            self.dummyImageView!.image = image
        })
    }
    
    

    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = self.items else {
            print("still no items")
            return 0
        }
        return items.count

    }
    
  
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        let cell:EbayTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! EbayTableViewCell

        if self.items != nil {
            let item = self.items![indexPath.row]
            cell.myTitle?.text = item.title
            cell.myTitle?.adjustsFontSizeToFitWidth = true
//            if let thisItem = item.itemImageView!.image {
//                cell.myImageView?.image = thisItem
//                return cell
//            }
//            else {
//                print("image didn't work")
//            }
          //  self.dummyImageView?.image
            ImageLoader.sharedLoader.imageForUrl(item.galleryURL!, completionHandler:{(image: UIImage?, url: String) in
                    cell.myImageView?.image = image
            })
            //print(self.imageDict[item.itemId!])
            //cell.myImageView?.image = self.dummyImageView?.image
//            if let thisImageView = item.itemImageView {
//                cell.myImageView?.image = thisImageView.image
//                print("image wasn't null")
            cell.setNeedsLayout()
        }
        return cell
    }




    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
}


class ImageLoader {
    
    var cache = NSCache()
    
    class var sharedLoader : ImageLoader {
        struct Static {
            static let instance : ImageLoader = ImageLoader()
        }
        return Static.instance
    }
    
    func imageForUrl(urlString: String, completionHandler:(image: UIImage?, url: String) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {()in
            let data: NSData? = self.cache.objectForKey(urlString) as? NSData
            
            if let goodData = data {
                let image = UIImage(data: goodData)
                dispatch_async(dispatch_get_main_queue(), {() in
                    completionHandler(image: image, url: urlString)
                })
                return
            }
            
            let downloadTask: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)!, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if (error != nil) {
                    completionHandler(image: nil, url: urlString)
                    return
                }
                
                if data != nil {
                    let image = UIImage(data: data!)
                    self.cache.setObject(data!, forKey: urlString)
                    dispatch_async(dispatch_get_main_queue(), {() in
                        completionHandler(image: image, url: urlString)
                    })
                    return
                }
                
            })
            downloadTask.resume()
        })
        
    }
}

//extension UIImageView {
//    public func imageFromUrl(urlString: String) {
//            if let url = NSURL(string: urlString) {
//                let request = NSURLRequest(URL: url)
//                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
//                    (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
//                    if let imageData = data as NSData? {
//                        self.image = UIImage(data: imageData)
//                        self.layoutSubviews()
//                    }
//                }
//            }
//        }
//}
