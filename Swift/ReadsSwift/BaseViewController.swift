//
//  BaseViewController.swift
//  ReadsSwift
//
//  Created by Ketan Shikhare on 07/07/20.
//

import UIKit
import BlueShift_iOS_SDK

//This class must be inherited by all the ViewControllers
class BaseViewController: UIViewController {
    //variable registerForInApp is set to true by default, so every ViewController will be registered for in-app automatically
    //after inheritiang this class
    //You can set registerForInApp to false in the ViewControllers didLoad method to not to register for in-app
    //This is one way to achieve this registration across the app, you can always customise it the way you want
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
    
    // Set color theme for different build configurations
    func setNavigationBarColor() {
        navigationController?.navigationBar.tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        if Bundle.main.bundleIdentifier == "com.blueshift.reads" {
            themeColor = UIColor(named: "appColor")
            
        } else {
            themeColor = UIColor(named: "AppColorRed")
        }
        navigationController?.navigationBar.barTintColor = themeColor
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }

}
