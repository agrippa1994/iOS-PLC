//
//  EditDataTableViewController.swift
//  PLC
//
//  Created by Manuel Stampfl on 06.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//

import UIKit

@objc protocol EditDataTableViewControllerDelegate {
    func editDataTableViewControllerDidCancel(controller: EditDataTableViewController)
    func editDataTableViewControllerDidSave(controller: EditDataTableViewController)
}

class EditDataTableViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var displayTypePickerView: UIPickerView!
    
    weak var delegate: EditDataTableViewControllerDelegate?
    var address: S7Entry?
    
    @IBAction func textFieldValueChanged(sender: UITextField) {
        // Parse the input to an entry for S7
        if let addr = try? sender.text?.toS7Entry() {
            self.address = addr
        } else {
            self.address = nil
        }
      
        // Set the text's color to red if the input is invalid otherwise to green
        sender.textColor =  self.address == nil ? UIColor.redColor() : UIColor.greenColor()
        
        // Update the details
        (self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1)) as! AddressDetailsTableViewCell).entry = self.address
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        self.delegate?.editDataTableViewControllerDidCancel(self)
    }
    
    @IBAction func onSave(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Open the keyboard
        self.nameTextField.becomeFirstResponder()
    }
}
