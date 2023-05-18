//
//  AppDelegate.swift
//  Blueshift Inbox
//
//  Created by Ketan Shikhare on 10/01/23.
//

import UIKit
import BlueShift_iOS_SDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let config: BlueShiftConfig = BlueShiftConfig()
        //Set account api key, and you can try sending the in-app notifications using test sends.
        //Also comment the `loadMessages` call.
        config.apiKey = "YOUR API KEY"
        config.enablePushNotification = true
        config.enableInAppNotification = true
        
        //enable mobile inbox
        config.enableMobileInbox = true
        
        // optional, debug enabled for development purpose.
        config.debug = true
        
        config.blueshiftDeviceIdSource = .UUID
        config.applicationLaunchOptions = launchOptions ?? [:]
        BlueShift.initWithConfiguration(config)
        
        //Comment load messages if you want to try test sends from you account.
        loadMessages()

        return true
    }

    // MARK: UISceneSession Lifecycle

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
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        BlueShift.sharedInstance()?.appDelegate?.register(forRemoteNotification: deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        BlueShift.sharedInstance()?.appDelegate?.handleRemoteNotification(userInfo, for: application, fetchCompletionHandler: completionHandler)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // handle deep links received from the inbox in-app notifications
        print("received deep link - \(url)")
        return true
    }
}

extension AppDelegate {
    func loadMessages() {
        BlueshiftInboxManager.deleteAllInboxMessagesFromDB();
        if let url = Bundle.main.url(forResource: "Inbox", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let jsonData = try JSONSerialization.jsonObject(with: data , options: .allowFragments)
                if let inboxMessages = jsonData as? [String: Any] {
                    BlueshiftInboxManager.processInboxMessages(forAPIResponse: inboxMessages, withCompletionHandler: { status in
                    })
                }
            } catch {
                print("Error!! Unable to parse  response.json")
            }
        }
    }
}
