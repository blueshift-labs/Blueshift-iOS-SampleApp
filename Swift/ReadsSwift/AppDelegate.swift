//
//  AppDelegate.swift
//  ReadsSwift
//
//  Created by Ketan on 18/05/20.
//

import UIKit
import BlueShift_iOS_SDK
import FirebaseCore
import Fabric

@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var activityIndicator: UIActivityIndicatorView? = nil
    var cartItems: [String: String] = [:]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //configure firebase for crashlytics
        var firbaseConfigFileName = ""
        if let bundleId = Bundle.main.bundleIdentifier, bundleId == "com.blueshift.reads.red" {
           firbaseConfigFileName = "\(bundleId)-GoogleService-Info"
        } else {
            firbaseConfigFileName = "GoogleService-Info"
        }
        if let path = Bundle.main.path(forResource: firbaseConfigFileName, ofType: "plist"),
            let firebaseOptions = FirebaseOptions(contentsOfFile: path) {
            FirebaseConfiguration.shared.setLoggerLevel(.min)
            FirebaseApp.configure(options: firebaseOptions)
            Fabric.sharedSDK().debug = true
        }

        // Obtain an instance of BlueShiftConfig
        let config = BlueShiftConfig()

        //Set debug true to see Blueshift SDK info logs, by default its set as false.
        config.debug = true;

        // Set the api Key for the config
        config.apiKey = "ADD API KEY"
//      config.enableLocationAccess = false
        
        //Enable push notifications
        config.enablePushNotification = true

        //Set user notification delegate
        if #available(iOS 10.0, *) {
            config.userNotificationDelegate = self
        }
        
        // For Carousel push notification deep linking set appGroup ids for different configs
        config.appGroupID = "group.blueshift.reads"
        
        //optinal: Disable inAppBackgroundFetchEnabled if you want to fetch in-apps manually via api
//        config.inAppBackgroundFetchEnabled = false;
//        
//        //optinal: Disable inAppManualTriggerEnabled if you want to display in-apps manually
//        config.inAppManualTriggerEnabled = true;
        
        //Enable In-app notifications
        config.enableInAppNotification = true

        //Optional: Set time interval in seconds between two In app notifications.
        //If you do not add below line, SDK by default sets it to 60 seconds.
        config.blueshiftInAppNotificationTimeInterval = 30

        //Optional: Set Batch upload interval in seconds.
        //If you do not add below line, SDK by default sets it to 300 seconds.
        BlueShiftBatchUploadConfig.sharedInstance()?.batchUploadTimer = 60

        //Set universal links delegate to enable universal links
        config.blueshiftUniversalLinksDelegate = self

        //Set deviceIDSource as custom
        config.blueshiftDeviceIdSource = .IDFV
        //Set the custom device id value
//        config.customDeviceId = UIDevice.current.identifierForVendor?.uuidString
        
//        //Optinal: Set push notification delegate to get the push events callback
//        let blueShiftPushDelegatge = BlueshiftPushNotificationEvents()
//        config.blueShiftPushDelegate = blueShiftPushDelegatge
//
//        //Optinal: Set in-app notification degate to get the in-app events callback
//        let blueshiftInAppDelegate = BlueshiftInAppNotificationEvents()
//        config.inAppNotificationDelegate = blueshiftInAppDelegate
        
        // Initialize the configuration
        BlueShift.initWithConfiguration(config)
        
        return true
    }
}

extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        BlueShift.sharedInstance()?.appDelegate.register(forRemoteNotification: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        BlueShift.sharedInstance()?.appDelegate.failedToRegisterForRemoteNotificationWithError(error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if BlueShift.sharedInstance()?.isBlueshiftPushNotification(userInfo) == true {
            BlueShift.sharedInstance()?.appDelegate.handleRemoteNotification(userInfo, for: application, fetchCompletionHandler: completionHandler)
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if BlueShift.sharedInstance()?.isBlueshiftPushNotification(response.notification.request.content.userInfo) == true {
            BlueShift.sharedInstance()?.userNotificationDelegate.handleUserNotification(center, didReceive: response, withCompletionHandler: completionHandler)
        }
    }
        
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if BlueShift.sharedInstance()?.isBlueshiftPushNotification(notification.request.content.userInfo) == true {
            BlueShift.sharedInstance()?.userNotificationDelegate.handle(center, willPresent: notification, withCompletionHandler: completionHandler)
        }
    }
}

extension AppDelegate {
    func applicationDidBecomeActive(_ application: UIApplication) {
        BlueShift.sharedInstance()?.appDelegate.appDidBecomeActive(application)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        BlueShift.sharedInstance()?.appDelegate.appDidEnterBackground(application)
    }
}

extension AppDelegate {
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let url = userActivity.webpageURL {
            if BlueShift.sharedInstance()?.isBlueshiftUniversalLinkURL(url) == true {
                BlueShift.sharedInstance()?.appDelegate.handleBlueshiftUniversalLinks(for: url)
            }
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        showProductDetail(animated: true, url: url)
        return true
    }
}

extension AppDelegate: BlueshiftUniversalLinksDelegate {
    
    func didCompleteLinkProcessing(_ url: URL?) {
        //Process deeplink and show the respective screen
        hideActivityIndicator()
        guard let url = url else { return }
        showProductDetail(animated: true, url: url)
    }
    
    func didStartLinkProcessing() {
        showActivityIndicator()
    }
    
    func didFailLinkProcessingWithError(_ error: Error?, url: URL?) {
        hideActivityIndicator()
    }
}

extension AppDelegate {
    func showActivityIndicator() {
        let rootViewController = UIApplication.shared.windows.first?.rootViewController
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
            activityIndicator?.color = .gray
        } else {
            activityIndicator = UIActivityIndicatorView(style: .gray)
        }
        activityIndicator?.center = rootViewController?.view.center ?? CGPoint(x: 0,y: 0)
        if let activityIndicator = activityIndicator {
            rootViewController?.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        activityIndicator?.removeFromSuperview()
    }
    
    func showAlert(for url: URL) {
        let rootViewController = UIApplication.shared.windows.first?.rootViewController
        let alertController = UIAlertController(title: "Product not found", message: url.absoluteString, preferredStyle: .alert)
        let open = UIAlertAction(title: "Open in Safari", style: .default) {
            UIAlertAction in
            DispatchQueue.main.async {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(open)
        alertController.addAction(cancel)
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func showProductDetail(animated: Bool, url: URL) {
        if url.absoluteString == "" {
            return
        } else if url.absoluteString == "//registerForNotification" {
            BlueShift.sharedInstance()?.appDelegate.registerForNotification()
            return
        }
        
        var newUrl = url.absoluteString.components(separatedBy: "?").first
        newUrl = newUrl?.replacingOccurrences(of: "http://", with: "https://")
        let products = Utils.shared.products.filter { (product) -> Bool in
            return product["web_url"] == newUrl ? true : false
        }
        guard let product = products.first else {
            showAlert(for: url)
            return
        }
        
        guard let navigationController = UIApplication.shared.windows.first?.rootViewController as? UINavigationController else { return }
        if navigationController.viewControllers.count > 2 {
            for controller in navigationController.viewControllers {
                if controller.isKind(of: ProductListViewController.self) {
                    navigationController.popToViewController(controller, animated: false)
                }
            }
        }
        
        let productDetailViewController: ProductDetailViewController?
        
        if #available(iOS 13.0, *) {
            productDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProductDetailViewController")
        } else {
            productDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController
        }
        if let productDetailViewController = productDetailViewController {
            productDetailViewController.product = product
            navigationController.pushViewController(productDetailViewController, animated: animated)
        }
    }
}
