//
//  EditServerTableViewController.swift
//  PLC
//
//  Created by Manuel Stampfl on 13.08.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import UIKit

@objc protocol EditServerTableViewControllerDelegate {
    func editServerTableViewServerChosen(server: Server)
}

class EditServerTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    weak var delegate: EditServerTableViewControllerDelegate?
    var server: Server!
 
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var hostTextField: UITextField!
    @IBOutlet weak var slotRackPickerView: UIPickerView!
    
    @IBAction func onConnect(sender: AnyObject) {
        self.loadDataFromUI()
        self.delegate?.editServerTableViewServerChosen(self.server)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.delegate = self
        self.hostTextField.delegate = self
        
        self.slotRackPickerView.dataSource = self
        self.slotRackPickerView.delegate = self
        
        self.loadDataToUI()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.loadDataFromUI()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return  2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 11
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func loadDataFromUI() {
        self.server.name = self.nameTextField.text
        self.server.host = self.hostTextField.text
        self.server.slot = Int32(self.slotRackPickerView.selectedRowInComponent(0))
        self.server.rack = Int32(self.slotRackPickerView.selectedRowInComponent(1))
        CoreData.coreData.save()
    }
    
    func loadDataToUI() {
        self.nameTextField.text = self.server.name
        self.hostTextField.text = self.server.host

        self.slotRackPickerView.selectRow(Int(self.server.slot), inComponent: 0, animated: false)
        self.slotRackPickerView.selectRow(Int(self.server.rack), inComponent: 1, animated: false)
    }
}
