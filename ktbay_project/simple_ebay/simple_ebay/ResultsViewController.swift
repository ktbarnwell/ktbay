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

    
    var searchString:String?
    var labelText:String?
    var dummyImageView:UIImageView?
    
    required init?(coder decoder: NSCoder) {
        self.dummyImageView = UIImageView()
        super.init(coder: decoder)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.rowHeight = 120
        self.tableView?.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
        self.loadItems()
        dispatch_async(dispatch_get_main_queue()) {
            if let myLabel = self.labelText {
                self.headLabel.text = myLabel
                self.reloadInputViews()
                self.tableView?.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            self.tableView?.reloadData()
          
        }
    }
            

    func getArray(search: SearchTerm?) {
        self.searchTerm = search
        if self.items == nil {
            self.items = self.searchTerm!.items
            self.tableView?.reloadData()
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
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = self.items else {
            return 0
        }
        return items.count

    }
    
  
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell:EbayTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! EbayTableViewCell

        if self.items != nil {
            let item = self.items![indexPath.row]
            cell.myTitle?.text = item.title
            cell.myTitle?.adjustsFontSizeToFitWidth = true
            let roundedPrice = String(format:"%.2f", item.price!)
            cell.priceLabel?.text = roundedPrice
            ImageLoader.sharedLoader.imageForUrl(item.galleryURL!, completionHandler:{(image: UIImage?, url: String) in
                    cell.myImageView?.image = image
            })

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