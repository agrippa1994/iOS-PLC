//
//  MainTableViewController.swift
//  PLC
//
//  Created by Manuel Stampfl on 03.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, ServerListTableViewControllerDelegate {
    var currentAlertController: UIAlertController?
    var client = S7Client()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0 ? "MAINCOLLECTIONVIEWCONTROLLER_STATIC_HEADER_TITLE" : "MAINCOLLECTIONVIEWCONTROLLER_DYNAMIC_HEADER_TITLE").localized
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ServerListNavigation" {
            if let ctrl = (segue.destinationViewController as? UINavigationController)?.topViewController as? ServerListTableViewController {
                ctrl.delegate = self
            }
        }
    }

    
    func serverListTableViewControllerServerChosen(controller: ServerListTableViewController, server: Server) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        self.currentAlertController = UIAlertController(title: "Info", message: "Baue Verbindung auf", preferredStyle: .Alert)
        
        self.presentViewController(self.currentAlertController!, animated: true) {
            self.client.connect(server.host!, rack: Int(server.rack), slot: Int(server.slot)) { state in
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
