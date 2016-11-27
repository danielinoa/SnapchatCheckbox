//
//  ViewController.swift
//  SnapchatCheckbox
//
//  Created by Daniel Inoa on 11/26/16.
//  Copyright © 2016 Daniel Inoa. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var checkbox: SnapchatCheckbox!
    @IBOutlet weak var isCheckedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isCheckedLabel.text = checkbox.isChecked ? "checked" : "unchecked"
    }
    
    @IBAction func checkboxTapped(_ sender: Any) {
        isCheckedLabel.text = checkbox.isChecked ? "checked" : "unchecked"
    }
    
}
