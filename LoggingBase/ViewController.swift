//
//  ViewController.swift
//  s
//
//  Created by Nguyễn Đức Thọ on 6/18/21.
//

import UIKit

class ViewController: UIViewController {
    var count = 0
    
    let textView = UITextView.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 200), size: CGSize.init(width: 300, height: 300)))
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .red
        let button = UIButton.init(type: .system)
        button.frame = CGRect.init(origin: .zero, size: CGSize.init(width: 100, height: 100))
        button.backgroundColor = .lightGray
        button.setTitle("fffffff", for: .normal)
        button.addTarget(self, action: #selector(printff), for: .touchUpInside)
        
        self.view.addSubview(button)
        self.view.addSubview(textView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        DebugManager.shared.consoleOutput.append({[weak self] tex in
//            guard let self = self else {return}
//            self.textView.text += tex
//        })
    }
    
    @objc func printff() {
        count += 1
        print(count)
    }
}
