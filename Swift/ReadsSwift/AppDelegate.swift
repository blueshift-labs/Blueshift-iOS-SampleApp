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
        
        // Optional (v2.1.12) - If your app uses SceneDelegate configuration, then enble this flag.
        if #available(iOS 13.0, *) {
            config.isSceneDelegateConfiguration = true
        }

        // optional - For Carousel push notification deep linking set appGroup id
        config.appGroupID = "group.blueshift.reads"

        // Optinal - Disable inAppBackgroundFetchEnabled if you want to fetch in-apps manually via api
//        config.inAppBackgroundFetchEnabled = false

       // Optinal - Disable inAppManualTriggerEnabled if you want to display in-apps manually
//        config.inAppManualTriggerEnabled = true

        // optional - Enable In-app notifications to use In-app notifications
        config.enableInAppNotification = true;

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

        // Initialize the configuration required to be executed on the main thread
        BlueShift.initWithConfiguration(config)
    }
}

// device tokens and push integration
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
            completionHandler([.alert, .sound, .badge])
        }
    }
}

// lifecycle events for batch uploads
extension AppDelegate {
    func applicationDidBecomeActive(_ application: UIApplication) {
        BlueShift.sharedInstance()?.appDelegate?.appDidBecomeActive(application)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        BlueShift.sharedInstance()?.appDelegate?.appDidEnterBackground(application)
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
            showProductDetail(animated: true, url: url)
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
    
    //Check for deep link and show rescpective screen/ perform respective action
    func showProductDetail(animated: Bool, url: URL) {
        if url.absoluteString == "" {
            return
        } else if url.absoluteString == "//registerForNotification" {
            BlueShift.sharedInstance()?.appDelegate?.registerForNotification()
            return
        }
        
        var newUrl = url.absoluteString.components(separatedBy: "?").first
        newUrl = newUrl?.replacingOccurrences(of: "http://", with: "https://")
        let products = Utils.shared?.products.filter { (product) -> Bool in
            return product["web_url"] == newUrl ? true : false
        }
        guard let product = products?.first else {
            showAlert(for: url)
            return
        }
        var navController: UINavigationController? = UIApplication.shared.windows.first?.rootViewController as? UINavigationController
        if #available(iOS 13.0, *) {
            // For sceneDelegate enabled apps, perform screen redirection in the keyWindow
            if BlueShift.sharedInstance()?.config?.isSceneDelegateConfiguration == true {
                navController = BlueShiftInAppNotificationHelper.getApplicationKeyWindow().windowScene?.windows.first?.rootViewController as? UINavigationController
            }
        }
                
        guard let navigationController = navController else {
            Utils.shared?.deepLinkURL = url
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

