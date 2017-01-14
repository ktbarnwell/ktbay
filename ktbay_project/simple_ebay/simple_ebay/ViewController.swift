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
    // rename later
    var searchString = ""
    
    @IBOutlet weak var labelView: UIView!
    // don't forget that we changed UITableView from an optional to an exlamation just now
    @IBOutlet weak var tableview: UITableView!
    //@IBOutlet weak var headerLabel: UILabel!
    
    init(stringForSearch: String) {
        super.init(nibName: nil, bundle: nil)
        self.searchString = stringForSearch
    }
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        //self.searchString = stringForSearch
    }
    
    // here we say that in order to instantiate a ViewController, you have to pass a string in the constructor
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableview?.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
        headerLabel.text = self.searchString
        // rename later
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
            
//            cell.imageView?.image = nil
//            if let urlString = item.galleryURL {
//                if let cellToUpdate = self.tableView?.cellForRow(at: indexPath) {
//                cellToUpdate.imageView?.image = image // will work fine even if image is nil
//                        // need to reload the view, which won't happen otherwise
//                        // since this is in an async call
//                cellToUpdate.setNeedsLayout()
//                }
//            //cell.detailTextLabel?.text = item.galleryURL
//            }
//        }
        
            
            }
        return cell
    }



    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }


}
    