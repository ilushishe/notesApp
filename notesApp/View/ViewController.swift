//
//  ViewController.swift
//  notesApp
//
//  Created by Ilya Kozlov on 04/07/2019.
//  Copyright © 2019 Ilya Kozlov. All rights reserved.
//

import UIKit
import CocoaLumberjack

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dynamicLogLevel = DDLogLevel.info
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DDLogInfo("My view controller did appear!")
    }
}

