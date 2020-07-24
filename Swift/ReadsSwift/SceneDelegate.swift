//
//  SceneDelegate.swift
//  ReadsSwift
//
//  Created by Ketan on 18/05/20.
//

import UIKit
import BlueShift_iOS_SDK

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let _ = (scene as? UIWindowScene) else { return }
        if let activity = connectionOptions.userActivities.first {
            BlueShift.sharedInstance()?.appDelegate.handleBlueshiftUniversalLinks(for: activity)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
//        let skuUrl = "blueshiftreads://ch.blueshift.reads/ProductListViewController/ProductDetailViewController/9780140247732"
            if url.absoluteString == "" {
                return
            }
            if url.absoluteString.contains("/ProductListViewController/ProductDetailViewController/") {
                let urlSKU = url.absoluteString.split(separator: "/").last ?? ""
                let products = Utils.shared.products.filter { (product) -> Bool in
                    if let productSKU = product["sku"], productSKU == urlSKU {
                        return true
                    }
                    return false
                }
                (UIApplication.shared.delegate as? AppDelegate)?.showProductDetail( animated: true, product: products.first)
            }
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        BlueShift.sharedInstance()?.appDelegate.handleBlueshiftUniversalLinks(for: userActivity)
    }
    
    func scene(_ scene: UIScene, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        print(userActivityType)
    }
}

