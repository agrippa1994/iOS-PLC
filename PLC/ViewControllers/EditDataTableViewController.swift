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
    var address: S7Address?
    var data: Data?
    var server: Server?
    
    @IBAction func textFieldValueChanged(sender: UITextField) {
        // Parse the input to an entry for S7
        if let addr = try? sender.text?.toS7Address() {
            self.address = addr
        } else {
            self.address = nil
        }
      
        // Set the text's color to red if the input is invalid otherwise to green
        sender.textColor =  self.address == nil ? UIColor.flatRedColorDark() : UIColor.flatGreenColorDark()
        
        // Update the details
        (self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1)) as! AddressDetailsTableViewCell).address = self.address
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        self.delegate?.editDataTableViewControllerDidCancel(self)
    }
    
    @IBAction func onSave(sender: AnyObject) {
        // Update address details view
        self.textFieldValueChanged(self.addressTextField)
        if self.address == nil {
            let ctrl = UIAlertController(title: "Info", message: "EDITDATATABLEVIEWCONTROLLER_INVALID_ADDRESS".localized, preferredStyle: .Alert)
            ctrl.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            return self.presentViewController(ctrl, animated: true, completion: nil)
        }
        
        guard let name = self.nameTextField.text else {
            let ctrl = UIAlertController(title: "Info", message: "EDITDATATABLEVIEWCONTROLLER_INVALID_NAME".localized, preferredStyle: .Alert)
            ctrl.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            return self.presentViewController(ctrl, animated: true, completion: nil)
        }
        
        if name.isEmpty {
            let ctrl = UIAlertController(title: "Info", message: "EDITDATATABLEVIEWCONTROLLER_INVALID_NAME".localized, preferredStyle: .Alert)
            ctrl.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(ctrl, animated: true, completion: nil)
            return
        }
        
        let isDynamicEntry = self.server != nil
        if isDynamicEntry && (self.server == nil || !(self.data is DynamicData)) {
            let ctrl = UIAlertController(title: "Info", message: "EDITDATATABLEVIEWCONTROLLER_INTERNAL_ERROR".localized, preferredStyle: .Alert)
            ctrl.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(ctrl, animated: true, completion: nil)
            return
        }
        
        // Create new CoreData object if neccessary
        self.data = self.data == nil
            ? isDynamicEntry ? CoreData.coreData.dynamicData.create(true)! : CoreData.coreData.staticData.create(true)! as Data
            : self.data
        
        self.data!.address = self.addressTextField!.text
        self.data!.displayType = Int32(self.displayTypePickerView.selectedRowInComponent(0))
        self.data!.name = name
        
        if isDynamicEntry && self.server != nil {
            (self.data as! DynamicData).server = self.server
        }
        
        // Save
        CoreData.coreData.save()
        
        // Notify the delegate
        self.delegate?.editDataTableViewControllerDidSave(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.delegate = self
        self.addressTextField.delegate = self
        
        self.displayTypePickerView.dataSource = self
        self.displayTypePickerView.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load data into the UI
        if self.data != nil {
            self.nameTextField.text = self.data!.name
            self.addressTextField.text = self.data!.address
            self.displayTypePickerView.selectRow(Int(self.data!.displayType), inComponent: 0, animated: false)
        }
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
