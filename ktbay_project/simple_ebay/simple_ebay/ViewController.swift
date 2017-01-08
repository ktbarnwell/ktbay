//
//  ViewController.swift
//  simple_ebay
//
//  Created by Katie Barnwell on 11/8/16.
//  Copyright © 2016 kt. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellIdentifier = "Cell"
    var items:Array<EbayItem>?
    var searchTerm:SearchTerm?
    
    @IBOutlet weak var tableview: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableview?.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
        self.loadItems()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadItems() {
        EbayItem.getItems {search, error in
            guard error == nil else {
                let alert = UIAlertController(title: "Error",
                    message: "Could not load first item \(error?.localizedDescription)",
                    preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            self.getArray(search)
            self.tableview?.reloadData()
        }
    }
            
        
    func getArray(search: SearchTerm?) {
        self.searchTerm = search
        if self.items == nil {
            self.items = self.searchTerm!.items
            self.tableview?.reloadData()
        }
        else {
            print("this is fucking hopeless")
        }
    }
    
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
//    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        if self.items != nil {
            let item = self.items![indexPath.row]
            cell.textLabel?.text = item.title
            var image = UIImageView!()
            if let url = NSURL(string: item.galleryURL) {
                if let data = NSData(contentsOfURL: url) {
                    imageURL.image = UIImage(data: data)
                }
            }
        
            }
        
        return cell
    }



    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }


}
    