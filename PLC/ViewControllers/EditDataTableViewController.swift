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

class EditDataTableViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
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
        
        self.nameTextField.delegate = self
        self.addressTextField.delegate = self
        
        self.displayTypePickerView.dataSource = self
        self.displayTypePickerView.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Open the keyboard
        self.nameTextField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ["DEC", "HEX", "BIN"][row]
    }
}
