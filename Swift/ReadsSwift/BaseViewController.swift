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
    
    //variable registerForInApp is set to true by default, so every ViewController will be registered for receiving in-app automatically after inheritiang this class
    //You can set registerForInApp to false in the ViewControllers "viewDidLoad" method to not to register for receiving in-app messages
    //This is one way to achieve this registration across the app, you can always customise it the way you want
    var registerForInApp: Bool = true
    
    var themeColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //adding this screen tracking here will automatically track screen views for all the VCs who are inheriting BaseViewController
        BlueShift.sharedInstance()?.trackScreenViewed(for: self, canBatchThisEvent: true)
        
        setupAppTheme()
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
    
    //Custom theme UI setup
    func setupAppTheme() {
        setNavigationBarColor()
        setNavigationBarButtons()
    }
}

extension BaseViewController {
    
    // Set color theme for different build configurations
    func setNavigationBarColor() {
        navigationController?.navigationBar.tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        if Bundle.main.bundleIdentifier == "com.blueshift.reads" {
            if #available(iOS 11.0, *) {
                themeColor = UIColor(named: "appColor")
            } else {
                themeColor = .blue
            }
        } else {
            if #available(iOS 11.0, *) {
                themeColor = UIColor(named: "AppColorRed")
            } else {
                themeColor = .red
            }
        }
        navigationController?.navigationBar.barTintColor = themeColor
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    //Add navigation button when manual trigger is enabled to show inapp
    func setNavigationBarButtons() {
        if BlueShift.sharedInstance()?.config.inAppManualTriggerEnabled == true {
            let showInAppButton = UIBarButtonItem(title: "Show InApp", style: .plain, target: self, action: #selector(showInApp));
            navigationItem.rightBarButtonItem = showInAppButton
        }
    }
    
    @objc func showInApp() {
        BlueShift.sharedInstance()?.displayInAppNotification()
    }
}
