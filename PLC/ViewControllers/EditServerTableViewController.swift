//
//  EditServerTableViewController.swift
//  PLC
//
//  Created by Manuel Stampfl on 13.08.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import UIKit

class EditServerTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    var server: Server!
 
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var hostTextField: UITextField!
    @IBOutlet weak var connectionTypePickerView: UIPickerView!
    @IBOutlet weak var slotRackPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.delegate = self
        self.hostTextField.delegate = self
        
        self.connectionTypePickerView.dataSource = self
        self.connectionTypePickerView.delegate = self
        
        self.slotRackPickerView.dataSource = self
        self.slotRackPickerView.delegate = self
        
        self.nameTextField.text = self.server.name
        self.hostTextField.text = self.server.host
        self.connectionTypePickerView.selectRow(self.server.connectionType.integerValue - 1, inComponent: 0, animated: false)
        self.slotRackPickerView.selectRow(self.server.slot.integerValue, inComponent: 0, animated: false)
        self.slotRackPickerView.selectRow(self.server.rack.integerValue, inComponent: 1, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.server.name = self.nameTextField.text
        self.server.host = self.hostTextField.text
        self.server.connectionType = NSNumber(integer: self.connectionTypePickerView.selectedRowInComponent(0) + 1)
        self.server.slot = NSNumber(integer: self.slotRackPickerView.selectedRowInComponent(0))
        self.server.rack = NSNumber(integer: self.slotRackPickerView.selectedRowInComponent(1))
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerView == self.connectionTypePickerView ? 1 : 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == self.connectionTypePickerView ? 3 : 11
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView == self.connectionTypePickerView {
            return S7ConnectionType(rawValue: word(row + 1))!.localizedString
        } else {
            return "\(row)"
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
