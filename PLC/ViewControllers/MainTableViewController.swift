//
//  MainTableViewController.swift
//  PLC
//
//  Created by Manuel Stampfl on 03.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, ServerListTableViewControllerDelegate, EditDataTableViewControllerDelegate {
    var currentAlertController: UIAlertController?
    var client = S7Client()
    var currentServer: Server?
    var dynamicData = [DynamicData]()
    var staticData = [Data]()
    
    @IBAction func onAdd(sender: UIBarButtonItem) {
        // When we are not connected to any server...
        if self.currentServer == nil {
            self.addDataEntry(isStatic: true)
        } else {
            // Otherwise the user can add an address entry for the current server or for all servers (static)
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            alertController.addAction(UIAlertAction(title: "MAINTABLEVIEWCONTROLLER_ADD_STATIC".localized, style: .Default) { _ in
                self.addDataEntry(isStatic: true)
            })
            
            alertController.addAction(UIAlertAction(title: "MAINTABLEVIEWCONTROLLER_ADD_DYNAMIC".localized, style: .Default) { _ in
                self.addDataEntry(isStatic: false)
            })
            
            alertController.addAction(UIAlertAction(title: "MAINTABLEVIEWCONTROLLER_ADD_CANCEL".localized, style: .Cancel, handler: nil))
            
            // Set the bar button item for the popover controller (neccessary for the iPad)
            alertController.popoverPresentationController?.barButtonItem = sender
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func onMore(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        alertController.addAction(UIAlertAction(title: "MAINTABLEVIEWCONTROLLER_MORE_STATISTIC".localized, style: .Default) { _ in
            
        })
        
        alertController.addAction(UIAlertAction(title: "MAINTABLEVIEWCONTROLLER_ADD_CANCEL".localized, style: .Cancel, handler: nil))
        
        // Set the bar button item for the popover controller (neccessary for the iPad)
        alertController.popoverPresentationController?.barButtonItem = sender
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Load everything from CoreData to this controller and display all values
        self.reloadData()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return ChameleonStatusBar.statusBarStyleForColor(self.navigationController!.navigationBar.barTintColor!)
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.staticData.count : self.dynamicData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BitCell", forIndexPath: indexPath)


        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
    }

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell")!
        cell.textLabel?.text = (section == 0 ? "MAINTABLEVIEWCONTROLLER_STATIC_HEADER_TITLE" : "MAINTABLEVIEWCONTROLLER_DYNAMIC_HEADER_TITLE").localized
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140.0
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ServerListNavigation" {
            if let ctrl = (segue.destinationViewController as? UINavigationController)?.topViewController as? ServerListTableViewController {
                ctrl.delegate = self
            }
        }
        
        if segue.identifier == "EditData" {
            if let ctrl = (segue.destinationViewController as? UINavigationController)?.topViewController as? EditDataTableViewController {
                ctrl.delegate = self
                ctrl.server = self.currentServer
                
                if let cell = sender as? UITableViewCell {
                    if let indexPath = self.tableView.indexPathForCell(cell) {
                        ctrl.data = indexPath.section == 0 ? self.staticData[indexPath.row] : self.dynamicData[indexPath.row]
                    }
                }
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
    
    func editDataTableViewControllerDidCancel(controller: EditDataTableViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func editDataTableViewControllerDidSave(controller: EditDataTableViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        self.reloadData()
    }
    
    func addDataEntry(isStatic isStatic: Bool) {
        self.performSegueWithIdentifier("EditData", sender: nil)
    }
    
    func reloadData() {
        self.dynamicData = CoreData.coreData.dynamicData.all()
        self.staticData = CoreData.coreData.staticData.all()
        self.tableView.reloadData()
    }
}
