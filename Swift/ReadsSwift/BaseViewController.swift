//
//  BaseViewController.swift
//  ReadsSwift
//
//  Created by Ketan Shikhare on 07/07/20.
//

import UIKit
import BlueShift_iOS_SDK

class BaseViewController: UIViewController {
    var registerForInApp: Bool = true
    var themeColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarColor()
    
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if registerForInApp {
            let viewControllerName = String(describing: type(of: self))
            BlueShift.sharedInstance()?.registerFor(inAppMessage: viewControllerName)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
            BlueShift.sharedInstance()?.unregisterForInAppMessage()
    }
    
    func setNavigationBarColor() {
        navigationController?.navigationBar.tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        if Bundle.main.bundleIdentifier == "com.blueshift.reads" {
            themeColor = UIColor(named: "appColor")
            
        } else {
            themeColor = UIColor(named: "AppColorRed")
        }
        navigationController?.navigationBar.barTintColor = themeColor
    }

}
