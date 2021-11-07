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
    }
    
    func updateDebug(_ log: String) {
        guard let textView = self.debugTextview else {return}
        textView.text += log
        textView.scrollToBottom()
    }
    
    
    @IBAction func close(_ sender: Any) {
        self.view.window?.resignKey()
        self.view.window?.isHidden = true
    }
}

extension UITextView {
    func scrollToBottom() {
        let textCount: Int = text.count
        guard textCount >= 1 else { return }
        scrollRangeToVisible(NSRange(location: textCount - 1, length: 1))
    }
}
