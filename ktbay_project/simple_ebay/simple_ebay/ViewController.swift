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
    var item:Array<EbayItem>?
    var isLoadingItem = false
    
    @IBOutlet weak var tableview: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableview?.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
        self.loadFirstItem()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadFirstItem() {
        isLoadingItem = true
        EbayItem.getItem { wrapper, error in
            guard error == nil else {
                self.isLoadingItem = false
                let alert = UIAlertController(title: "Error",
                    message: "Could not load first item \(error?.localizedDescription)",
                    preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
//            self.addItemFromWrapper(wrapper)
            self.isLoadingItem = false
            self.tableview?.reloadData()
        }
    }
    
//    func addItemFromWrapper(wrapper: ItemWrapper?)
//    {
//        self.itemWrapper = wrapper
//        if self.item == nil
//        {
//            self.item = self.itemWrapper?.item
//        }
//        else if self.itemWrapper != nil && self.itemWrapper!.item != nil
//        {
//            self.item = self.item! + self.itemWrapper!.item!
//        }
//    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.item == nil {
            return 0
        }
        return self.item!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if let numberOfItems = self.item?.count where numberOfItems >= indexPath.row {
            if let item = self.item?[indexPath.row] {
                cell.textLabel?.text = item.title
                cell.detailTextLabel?.text = item.galleryURL
            }
            
            /* let rowsToLoadFromBottom = 5;
            if !self.isLoadingItems && indexPath.row >= (numberOfItems - rowsToLoadFromBottom) {
            if let totalItemCount = self.itemWrapper?.count where totalItemCount - numberOfItems > 0 {
            self.loadMoreItems()
            } */
            
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

    