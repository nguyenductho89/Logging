//
//  ViewController.swift
//  s
//
//  Created by Nguyễn Đức Thọ on 6/18/21.
//

import UIKit
import OSLog

//class ViewController: UIViewController {
//    override func viewDidLoad() {
//        self.view.backgroundColor = .green
//    }
//}

class ConsolePipe {
    //open a new Pipe to consume the messages on STDOUT and STDERR
    private let inputPipe = Pipe()
    //open another Pipe to output messages back to STDOUT
    private let outputPipe = Pipe()
    
    static let share = ConsolePipe()
    
    static func startLog() {
        ConsolePipe.share.openConsolePipe()
    }
    
    private func openConsolePipe() {
        let pipeReadHandle = inputPipe.fileHandleForReading
        //from documentation
        //dup2() makes newfd (new file descriptor) be the copy of oldfd (old file descriptor), closing newfd first if necessary.
        
        //here we are copying the STDOUT file descriptor into our output pipe's file descriptor
        //this is so we can write the strings back to STDOUT, so it can show up on the xcode console
        
        dup2(STDOUT_FILENO, outputPipe.fileHandleForWriting.fileDescriptor)
        
        //In this case, the newFileDescriptor is the pipe's file descriptor and the old file descriptor is STDOUT_FILENO and STDERR_FILENO
        
        dup2(inputPipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
        dup2(inputPipe.fileHandleForWriting.fileDescriptor, STDERR_FILENO)
        
        //listen in to the readHandle notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.handlePipeNotification), name: FileHandle.readCompletionNotification, object: pipeReadHandle)
        
        //state that you want to be notified of any data coming across the pipe
        pipeReadHandle.readInBackgroundAndNotify()
    }
    
    @objc private func handlePipeNotification(notification: Notification) {
        //note you have to continuously call this when you get a message
        //see this from documentation:
        //Note that this method does not cause a continuous stream of notifications to be sent. If you wish to keep getting notified, you’ll also need to call readInBackgroundAndNotify() in your observer method.
        inputPipe.fileHandleForReading.readInBackgroundAndNotify()
        
        if let data = notification.userInfo?[NSFileHandleNotificationDataItem] as? Data,
           let str = String(data: data, encoding: String.Encoding.ascii) {
            DispatchQueue.main.async {
                ConsolePipe.consoleOutput?(str)
                    }
            //write the data back into the output pipe. the output pipe's write file descriptor points to STDOUT. this allows the logs to show up on the xcode console
            outputPipe.fileHandleForWriting.write(data)
            
            // `str` here is the log/contents of the print statement
            //if you would like to route your print statements to the UI: make
            //sure to subscribe to this notification in your VC and update the UITextView.
            //Or if you wanted to send your print statements to the server, then
            //you could do this in your notification handler in the app delegate.
        }
    }
    
    static var consoleOutput: ((String) -> Void)?

}

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
        ConsolePipe.consoleOutput = {[weak self] logString in
            self?.textView.text += logString
        }
    }
    
    @objc func printff() {
        count += 1
        print(count)
    }
}
