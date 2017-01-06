//
//  SearchController.swift
//  simple_ebay
//
//  Created by Katie Barnwell on 1/5/17.
//  Copyright © 2017 kt. All rights reserved.
//

import UIKit

class SearchController: UIViewController {

    @IBOutlet weak var searchLabel: UILabel!
    
    @IBAction func searchButton(sender: AnyObject) {
        let myVC = storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        myVC.stringPassed = searchLabel.text!
        navigationController?.pushViewController(myVC, animated: true)
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

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

}
