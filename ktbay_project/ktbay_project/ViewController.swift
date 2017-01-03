//
//  ViewController.swift
//  ktbay_project
//
//  Created by Katie Barnwell on 11/1/16.
//  Copyright © 2016 kt. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellIdentifier = "Cell"
    var items: [EbayItem]?
    var itemWrapper:ItemWrapper? // holds the last wrapper that we've loaded
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
        EbayItem.getItem({ (itemWrapper, error) in
            guard error == nil else {
                self.isLoadingItem = false
                let alert = UIAlertController(title: "Error",
                    message: "Could not load first item \(error?.localizedDescription)",
                    preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            self.addItemsFromWrapper(itemWrapper)
            self.isLoadingItem = false
            self.tableview?.reloadData()
        })
    }
    
    
    func addItemsFromWrapper(wrapper: ItemWrapper?){
        self.itemWrapper = wrapper
        if self.items == nil
        {
            self.items = self.itemWrapper?.items
        }
        else if let newItem = self.itemWrapper?.items, let currentItem = self.items {
            self.items = currentItem + newItem
        }
    }
    
    func loadMoreItems()
    {
        self.isLoadingItem = true
        guard let items = self.items, let wrapper = self.itemWrapper where items.count < wrapper.count else {
            // no more items to fetch
            return
        }
        
        EbayItem.getMoreItems(self.itemWrapper, completionHandler: { (moreWrapper, error) in
            guard error == nil else {
                // TODO: improved error handling
                self.isLoadingItem = false
                let alert = UIAlertController(title: "Error", message: "Could not load more items \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            print("got more items")
            self.addItemsFromWrapper(moreWrapper)
            self.isLoadingItem = false
            self.tableview?.reloadData()
        })
    }

    


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = self.items else {
            return 0
        }
        return items.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if let numberOfItems = self.items?.count where numberOfItems >= indexPath.row {
            if let item = self.items?[indexPath.row] {
                cell.textLabel?.text = item.title
                cell.detailTextLabel?.text = String(item.itemId)
            }
            
            // See if we need to load more species
            let rowsToLoadFromBottom = 5;
            if !self.isLoadingItem && indexPath.row >= (numberOfItems - rowsToLoadFromBottom) {
                if let totalItemCount = self.itemWrapper?.count where totalItemCount - numberOfItems > 0 {
                    self.loadMoreItems()
                }
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row % 2 == 0
        {
            cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0) // very light gray
        }
        else
        {
            cell.backgroundColor = UIColor.whiteColor()
        }

    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}


