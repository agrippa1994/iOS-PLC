//
//  MainCollectionViewController.swift
//  PLC
//
//  Created by Manuel Stampfl on 02.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//

import UIKit

class MainCollectionViewController: UICollectionViewController, ServerListTableViewControllerDelegate {
    var currentAlertController: UIAlertController?
    var client = S7Client()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
 
        AppDelegate.singleton.window?.tintColor = UIColor.redColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ServerListNavigation" {
            if let ctrl = (segue.destinationViewController as? UINavigationController)?.topViewController as? ServerListTableViewController {
                ctrl.delegate = self
            }
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 5
    }

    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
    
        // Configure the cell
    
        return cell
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == "UICollectionElementKindSectionHeader" {
            let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath)
            let label = cell.viewWithTag(100) as! UILabel
            
            label.text = (indexPath.section == 0 ? "MAINCOLLECTIONVIEWCONTROLLER_STATIC_HEADER_TITLE" : "MAINCOLLECTIONVIEWCONTROLLER_DYNAMIC_HEADER_TITLE").localized
            
            return cell
        }
        
        return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
        
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    func serverListTableViewControllerServerChosen(controller: ServerListTableViewController, server: Server) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        self.currentAlertController = UIAlertController(title: "Info", message: "Baue Verbindung auf", preferredStyle: .Alert)
        
        self.presentViewController(self.currentAlertController!, animated: true) {
            self.client.connect(server.host, rack: server.rack.integerValue, slot: server.slot.integerValue) { state in
                dispatch_async(dispatch_get_main_queue()) {
                    self.currentAlertController?.dismissViewControllerAnimated(true) {
                        let texts = state == 0 ? ("ALERT_INFO_TITLE", "ALERT_INFO_CONNECTED_MESSAGE") : ("ALERT_ERROR_TITLE", "ALERT_ERROR_CONNECT_MESSAGE")
                    
                        self.currentAlertController = UIAlertController(title: texts.0.localized, message: texts.1.localized, preferredStyle: .Alert)
                
                        
                        self.currentAlertController!.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { action in
                            self.currentAlertController!.dismissViewControllerAnimated(true, completion: nil)
                        })
                        
                        self.presentViewController(self.currentAlertController!, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func serverListTableViewControllerCancelled(controller: ServerListTableViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
