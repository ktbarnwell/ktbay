//
//  ResultsViewController.swift
//  simple_ebay
//
//  Created by Katie Barnwell on 11/8/16.
//  Copyright © 2016 kt. All rights reserved.
//

import UIKit
import Foundation

class ResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let cellIdentifier = "Cell"
    var items:Array<EbayItem>?
    var searchTerm:SearchTerm?
    // rename later
    // when we have searchString as set to something here via the code, it DOES show up. ok!
    //var searchString = "test string"
    var searchString: String?
    
       // don't forget that we changed UITableView from an optional to an exlamation just now
    @IBOutlet weak var tableview: UITableView?
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var labelView: UIView!

    
    // old inits here - do not remove
    init(stringForSearch: String?) {
        if let thisString = stringForSearch {
            self.searchString = thisString
        }
        else {
            print("i hate swift")
        }
        //self.searchString = stringForSearch
        super.init(nibName: nil, bundle: nil)
        print("we hit stringForSearch init")
        }
    
    required init?(coder decoder: NSCoder) {
        print("we hit coder decoder init")
        super.init(coder: decoder)
        //self.searchString = stringForSearch
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableview?.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
        print("printing self.searchString from viewDidLoad")
        print(self.searchString)
        //headerLabel.text = self.searchString
        // rename later
        self.loadItems()
        dispatch_async(dispatch_get_main_queue()) {
            // when we set headerLabel.text explicitly to some text, it works!
            if let myLabel = self.searchString {
                self.headerLabel.text = myLabel
                // HOLY FUCK!!!! when we unwrap, 'guess it's still zero' prints but text displayed is "Label"
            }
            else {
                print(self.searchString)
                //self.headerLabel.text = "default text";
                print("guess it's still zero")
            }
        self.reloadInputViews()
        }
       

        
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
    