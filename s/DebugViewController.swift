//
//  DebugViewController.swift
//  SBOfficial
//
//  Created by Nguyen Duc Tho on 23/10/2021.
//  Copyright © 2021 Softbank. All rights reserved.
//

import UIKit
class DebugViewController: UIViewController {

    @IBOutlet weak var debugTextview: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDebug()
    }
    
    func updateDebug() {
        ConsolePipe.consoleOutput = {[weak self] logString in
            self?.debugTextview.text += logString
        }
    }
    
    
    @IBAction func close(_ sender: Any) {
        self.view.window?.resignKey()
        self.view.window?.isHidden = true
    }
}
