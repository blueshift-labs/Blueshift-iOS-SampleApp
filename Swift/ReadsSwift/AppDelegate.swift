//
//  AppDelegate.swift
//  ReadsSwift
//
//  Created by Ketan on 18/05/20.
//

import UIKit
import BlueShift_iOS_SDK

@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var activityIndicator: UIActivityIndicatorView? = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        initialiseBlueshiftSDK(launchOptions: launchOptions)
        return true
    }
    
    func initialiseBlueshiftSDK(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // Obtain an instance of BlueShiftConfig
        let config = BlueShiftConfig()

        // Optional (v2.2.3) - Set Blueshift Region, default region is US.
//        config.region =  .US //  EU or US

        // Set the api Key
        config.apiKey = "YOUR API KEY"
        
        // Optional (v2.1.7) - Set debug true to see Blueshift SDK info logs, by default its set as false.
        config.debug = true
        
        //Optinal - Set custom Authorization Options. SDK sets [.alert, .badge, .sound] as default attributes.
        if #available(iOS 12.0, *) {
            config.customAuthorizationOptions = [.alert, .badge, .sound, .providesAppNotificationSettings]
        }

        //Optinal - Set custom push notification categories.
        if #available(iOS 11.0, *) {
            config.customCategories = getCustomeCategories();
        }

        // By default flag is set as true to show push notification dialog immediately after launch
        // Set this to false to delay the push permission dialog
        config.enablePushNotification = false

        // Set this flag to false to disable the silent push registration
//        config.enableSilentPushNotification = false

        // Set launch options to SDK to process then if app is launched from killed state using push notification
        if let launchOptions = launchOptions {
            config.applicationLaunchOptions = launchOptions
        }

        // Set user notification delegate, Blueshift SDK uses it while registering for push notifications
        if #available(iOS 10.0, *) {
            config.userNotificationDelegate = self
        }

        // optional - For Carousel push notification deep linking set appGroup id
        config.appGroupID = "group.blueshift.reads"

        // Optinal - Disable inAppBackgroundFetchEnabled if you want to fetch in-apps manually via api
//        config.inAppBackgroundFetchEnabled = false

       // Optinal - Disable inAppManualTriggerEnabled if you want to display in-apps manually
//        config.inAppManualTriggerEnabled = true

        // optional - Enable In-app notifications to use In-app notifications
        config.enableInAppNotification = true;

        // optional - Enable mobile inbox functionality
        config.enableMobileInbox = true
        // Optional: Set time interval in seconds between two In app notifications.
        // If you do not add below line, SDK by default sets it to 60 seconds.
//        config.blueshiftInAppNotificationTimeInterval = 60

        // Optional: Set Batch upload interval in seconds.
        // If you do not add below line, SDK by default sets it to 300 seconds.
        BlueShiftBatchUploadConfig.sharedInstance()?.batchUploadTimer = 30

        // optional v2.1.0 - Set universal links delegate to enable universal links
        config.blueshiftUniversalLinksDelegate = self

        // optional - Enable app open event, by default it is set to false.
        config.enableAppOpenTrackEvent = true
        
        //optional - Set app open time interval
//        config.automaticAppOpenTimeInterval = 60

        // Optional (v2.1.3):  - Set deviceIDSource, by default it is IDFV
        config.blueshiftDeviceIdSource = .idfvBundleID
        
        // Optinal: Set push notification delegate to get the push events callback
        let blueShiftPushDelegatge = BlueshiftPushNotificationEvents()
        config.blueShiftPushDelegate = blueShiftPushDelegatge

        // Optinal: Set in-app notification degate to get the in-app events callback
        let blueshiftInAppDelegate = BlueshiftInAppNotificationEvents()
        config.inAppNotificationDelegate = blueshiftInAppDelegate

        // Optional: Change the SDK core data files location only if needed. The default location is the Document directory.
        config.sdkCoreDataFilesLocation = .libraryDirectory
        
        // Initialize the configuration required to be executed on the main thread
        BlueShift.initWithConfiguration(config)
    }
    
     //MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

/// device tokens and push integration
extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        BlueShift.sharedInstance()?.appDelegate?.register(forRemoteNotification: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        BlueShift.sharedInstance()?.appDelegate?.failedToRegisterForRemoteNotificationWithError(error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // v2.1.8 - Filter Blueshift notifications
        if BlueShift.sharedInstance()?.isBlueshiftPushNotification(userInfo) == true {
            BlueShift.sharedInstance()?.appDelegate?.handleRemoteNotification(userInfo, for: application, fetchCompletionHandler: completionHandler)
        } else {
            completionHandler(.noData)
        }
    }
}

// push notification callbacks integration
extension AppDelegate: UNUserNotificationCenterDelegate {
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // v2.1.8 - Filter Blueshift notifications
        if BlueShift.sharedInstance()?.isBlueshiftPushNotification(response.notification.request.content.userInfo) == true {
            BlueShift.sharedInstance()?.userNotificationDelegate?.handleUserNotification(center, didReceive: response, withCompletionHandler: completionHandler)
            //fire
        } else {
            completionHandler()
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // v2.1.8 - Filter Blueshift notifications
        if BlueShift.sharedInstance()?.isBlueshiftPushNotification(notification.request.content.userInfo) == true {
            BlueShift.sharedInstance()?.userNotificationDelegate?.handle(center, willPresent: notification, withCompletionHandler: completionHandler)
        } else {
            if #available(iOS 14.0, *) {
                completionHandler([.banner, .list, .sound, .badge])
            } else {
                completionHandler([.alert, .sound, .badge])
            }
        }
    }
}
 
// Universal links and push+inapp deep links setup
extension AppDelegate {
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let url = userActivity.webpageURL {
            if BlueShift.sharedInstance()?.isBlueshiftUniversalLinkURL(url) == true {
                BlueShift.sharedInstance()?.appDelegate?.handleBlueshiftUniversalLinks(for: url)
            }
        }
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // v2.1.12 - Check if deep link url is from Blueshift.
        if let source = options[UIApplication.OpenURLOptionsKey(rawValue: "source")] as? String, source == "Blueshift" {
            showProductDetail(animated: true, url: url, options:options)
        } else {
            //handle it seperately
        }
        return true
    }
}

// Universal links callbacks
extension AppDelegate: BlueshiftUniversalLinksDelegate {
    
    func didCompleteLinkProcessing(_ url: URL?) {
        //Process deeplink and show the respective screen
        hideActivityIndicator()
        guard let url = url else { return }
        showProductDetail(animated: true, url: url, options:[:])
    }
    
    func didStartLinkProcessing() {
        showActivityIndicator()
    }
    
    func didFailLinkProcessingWithError(_ error: Error?, url: URL?) {
        hideActivityIndicator()
    }
}

extension AppDelegate {
    @available(iOS 11.0, *)
    func getCustomeCategories() -> Set<UNNotificationCategory> {
        // Define the custom actions.
        let acceptAction = UNNotificationAction(identifier: "YES",
              title: "Yes",
              options: .foreground)
        let declineAction = UNNotificationAction(identifier: "NO",
              title: "No",
              options: .destructive)
        // Define the notification type
        if #available(iOS 12.0, *) {
            let meetingInviteCategory =
            UNNotificationCategory(identifier: "MEETING_INVITATION",
                                   actions: [acceptAction, declineAction],
                                   intentIdentifiers: [],
                                   hiddenPreviewsBodyPlaceholder: "",
                                   categorySummaryFormat: "%u messages from %s",
                                   options: .customDismissAction)
            return [meetingInviteCategory];
        } else {
            let meetingInviteCategory =
            UNNotificationCategory(identifier: "MEETING_INVITATION",
                                   actions: [acceptAction, declineAction],
                                   intentIdentifiers: [],
                                   hiddenPreviewsBodyPlaceholder: "",
                                   options: .customDismissAction)
            return [meetingInviteCategory];
            
        }
    }
}

//Process deep link to land on specific screen, hide/show activity indicator
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
    
    func showAlert(for titile: String?, message: String?) {
        if #available(iOS 13.0, *) {
            let navController = BlueShiftInAppNotificationHelper.getApplicationKeyWindow().windowScene?.windows.first?.rootViewController?.navigationController
            
            let alertController = UIAlertController(title: titile, message: message, preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .cancel)
            alertController.addAction(okay)
            navController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    //Check for deep link and show rescpective screen/ perform respective action
    func showProductDetail(animated: Bool, url: URL, options:[UIApplication.OpenURLOptionsKey : Any]) {
        if url.absoluteString == "" {
            return
        }
        
        //Get product for the given deep link
        
        //Get current navigation controller
        var navController: UINavigationController? = UIApplication.shared.windows.first?.rootViewController as? UINavigationController
        if #available(iOS 13.0, *) {
            // For sceneDelegate enabled apps, perform screen redirection in the keyWindow
            navController = BlueShiftInAppNotificationHelper.getApplicationKeyWindow().windowScene?.windows.first?.rootViewController as? UINavigationController
            navController?.dismiss(animated: false)
        }
        
        // If navigation controller not found, then cache the deep link url for later use
        guard let navigationController = navController else {
            Utils.shared?.deepLinkURL = url
            return
        }
        
        //If product not found, show alert with deep link url.
        guard let product = getProductForURL(url: url.absoluteString)?.first else {
            showAlert(for: "Product not found", message: url.absoluteString)
            return
        }
        
        if navigationController.viewControllers.count > 2 {
            for controller in navigationController.viewControllers {
                if controller.isKind(of: ProductListViewController.self) {
                    navigationController.popToViewController(controller, animated: false)
                    break
                }
            }
        } else if navigationController.viewControllers.count <= 1 {
            // if app is not loaded completely.
            Utils.shared?.deepLinkURL = url
            return
        }
        showProductUsing(navigationController: navigationController, product: product, animated: true)
    }
    
    func getProductForURL(url: String) -> [[String:String]]? {
        var newUrl = url.components(separatedBy: "?").first
        newUrl = newUrl?.replacingOccurrences(of: "http://", with: "https://")
        let products = Utils.shared?.products.filter { (product) -> Bool in
            return product["web_url"] == newUrl ? true : false
        }
        return products
    }
    
    func showProductUsing(navigationController: UINavigationController, product: [String: String]?, animated: Bool) {
        let productDetailViewController: ProductDetailViewController?
        
        if #available(iOS 13.0, *) {
            productDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProductDetailViewController")
        } else {
            productDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController
        }
        if let productDetailViewController = productDetailViewController {
            productDetailViewController.product = product
            navigationController.show(productDetailViewController, sender: nil);
        }
    }
}

