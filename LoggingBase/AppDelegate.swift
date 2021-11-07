//
//  AppDelegate.swift
//  s
//
//  Created by Nguyễn Đức Thọ on 6/18/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var debugWindow: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
       
//        //Trigger logging top most view controller
        guard let window = window else {
            return true
        }
        DebugManager.shared.startDebugWindow(window)
        print("appdelega ")

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    


}

class TLogger {
    static func start() {
        //        That's because with the app running disconnected from Xcode stdout is redirected to something like /dev/null with buffering set to "buffered" and thus never appears in the pipe(). Setting it to unbuffered made things work.
        setvbuf(stdout, nil, _IOLBF, 0)
        NotificationCenter.default.addObserver(self, selector: #selector(logTopMostViewController), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }
    @objc static func logTopMostViewController() {
        guard let view = UIApplication.shared.keyWindow?.rootViewController?.topMostViewController().view else {
            print("Cannot debug ui")
            return
        }
        print(String(data: try! JSONSerialization.data(withJSONObject: view.jsonDescription(), options: .prettyPrinted), encoding: .utf8 )!)
    }
}

extension UIView {
    @objc func jsonDescription() -> Dictionary<String, Any> {
        let sub = self.subviews.compactMap {$0.jsonDescription()}
        guard !sub.isEmpty else {
            return [String(describing: Self.self):""]
        }
        return [String(describing: Self.self):sub]
    }
}

extension UIButton {
    override func jsonDescription() -> Dictionary<String, Any> {
        return [String(describing: Self.self):[
            "frame": "\(self.frame)",
            "title": self.currentTitle ?? ""
        ]]
    }
}

extension UILabel {
    override func jsonDescription() -> Dictionary<String, Any> {
        return [String(describing: Self.self):[
            "frame":"\(self.frame)",
            "text": self.text ?? "",
            "attributedText": self.attributedText?.string ?? ""
        ]]
    }
}

extension UITextView {
    override func jsonDescription() -> Dictionary<String, Any> {
        return [String(describing: Self.self):[
            "frame":"\(self.frame)",
            "text": self.text ?? "",
        ]]
    }
}

extension UITextField {
    override func jsonDescription() -> Dictionary<String, Any> {
        return [String(describing: Self.self):[
            "frame":"\(self.frame)",
            "text": self.text ?? "",
        ]]
    }
}

extension UICollectionView {
    override func jsonDescription() -> Dictionary<String, Any> {
        return [String(describing: Self.self):[
                    "frame":"\(self.frame)"        ]]
    }
}

extension UITableView {
    override func jsonDescription() -> Dictionary<String, Any> {
        return [String(describing: Self.self):[
                    "frame":"\(self.frame)"        ]]
    }
}

extension UITableViewCell {
    override func jsonDescription() -> Dictionary<String, Any> {
        return [String(describing: Self.self): self.contentView.jsonDescription()]
    }
}

extension UIImageView {
    override func jsonDescription() -> Dictionary<String, Any> {
        return [String(describing: Self.self):[
                    "frame":"\(self.frame)"        ]]
    }
}

extension UIViewController {
    @objc func topMostViewController() -> UIViewController {
        // Handling Modal views
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController()
        }
        // Handling UIViewController's added as subviews to some other views.
        else {
            for view in self.view.subviews
            {
                // Key property which most of us are unaware of / rarely use.
                if let subViewController = view.next {
                    if subViewController is UIViewController {
                        let viewController = subViewController as! UIViewController
                        return viewController.topMostViewController()
                    }
                }
            }
            return self
        }
    }
}

extension UITabBarController {
    override func topMostViewController() -> UIViewController {
        return self.selectedViewController!.topMostViewController()
    }
}

extension UINavigationController {
    override func topMostViewController() -> UIViewController {
        return self.visibleViewController!.topMostViewController()
    }
}
